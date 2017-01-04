/**
 * This Source Code Form is subject to the terms of 
 * the Mozilla Public License, v. 2.0. If a copy of 
 * the MPL was not distributed with this file, You 
 * can obtain one at https://mozilla.org/MPL/2.0/.
 */
package top.marchand.xml.xsl.doc;

import fr.efl.chaine.xslt.StepJava;
import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.Stack;
import javax.xml.transform.stream.StreamSource;
import net.sf.saxon.Configuration;
import net.sf.saxon.event.ProxyReceiver;
import net.sf.saxon.event.Receiver;
import net.sf.saxon.expr.parser.Location;
import net.sf.saxon.om.NodeName;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.Serializer;
import net.sf.saxon.s9api.XdmAtomicValue;
import net.sf.saxon.s9api.XsltExecutable;
import net.sf.saxon.s9api.XsltTransformer;
import net.sf.saxon.trans.XPathException;
import net.sf.saxon.type.SchemaType;
import net.sf.saxon.type.SimpleType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * This class accumulates the files that are processed, and on then,
 * is able to generates a entries list as an XML file.
 * 
 * @author cmarchand
 */
public class AccumulatorStep extends StepJava {
    public static final String NS = "top:marchand:xml:xsl:doc";
    private static final Logger LOGGER = LoggerFactory.getLogger(AccumulatorStep.class);
    private static final Stack<Triple> INPUT_FILES = new Stack<>();
    private static String outputDir;
    private static String absoluteRootFolder;

    String currentInputFile;

    @Override
    public Receiver getReceiver(Configuration c) throws SaxonApiException {
        currentInputFile = getParameter(new QName("input-absolute")).toString();
        outputDir = getParameter(new QName("outputFolder")).toString();
        absoluteRootFolder = getParameter(new QName("absoluteRootFolder")).toString();
        return new AccumulatorStepReceiver(getNextReceiver(c));
    }
    
    private class AccumulatorStepReceiver extends ProxyReceiver {
        private final Stack<NodeName> stack;
        private String currentElementName;

        public AccumulatorStepReceiver(Receiver nextReceiver) {
            super(nextReceiver);
            stack = new Stack<>();
        }

        @Override
        public void startElement(NodeName elemName, SchemaType typeCode, Location location, int properties) throws XPathException {
            super.startElement(elemName, typeCode, location, properties);
            currentElementName = elemName.getLocalPart();
            stack.push(elemName);
            if("file".equals(currentElementName)) {
                if(stack.size()==1) {
                    INPUT_FILES.push(new Triple(currentInputFile, null, absoluteRootFolder));
                }
            }
        }

        @Override
        public void endElement() throws XPathException {
            super.endElement();
            stack.pop();
        }

        @Override
        public void attribute(NodeName nameCode, SimpleType typeCode, CharSequence value, Location locationId, int properties) throws XPathException {
            super.attribute(nameCode, typeCode, value, locationId, properties);
            if("file".equals(currentElementName)) {
                if(stack.size()==1) {
                    if(nameCode.getLocalPart().equals("welcomeOutputUri")) {
                        LOGGER.debug("setting targetUri="+value.toString());
                        INPUT_FILES.peek().targetUri = value.toString();
                    } else if(nameCode.getLocalPart().equals("levelsToKeep")) {
                        INPUT_FILES.peek().levelsToKeep = Integer.parseInt(value.toString());
                    } else if(nameCode.getLocalPart().equals("index-label")) {
                        INPUT_FILES.peek().label = value.toString();
                    }
                }
            }
        }
    }
    /**
     * Generates the index File
     * @param projectName
     * @return The generated index file, or null if it was impossible to generate it.
     * @throws IOException
     * @throws SaxonApiException
     * @throws URISyntaxException 
     */
    static File generateIndex(String projectName) throws IOException, SaxonApiException, URISyntaxException {
        // we do not work with absolute anymore, only relatives
        if(outputDir!=null) {
            String outputPath = new File(new URI(outputDir)).getAbsolutePath();
            StringBuilder sb = new StringBuilder();
            for(Triple triple:INPUT_FILES) {
                LOGGER.debug(triple.toString());
                String targetReadUri = new File(new URI(triple.targetUri)).getAbsolutePath();
                String targetUri = targetReadUri.subSequence(outputPath.length()+1, targetReadUri.length()).toString();
                String sourceUri = triple.label;
                sb.append(sourceUri).append("@").append(targetUri).append("@").append(triple.levelsToKeep).append("|");
            }
            String data = sb.deleteCharAt(sb.length()-1).toString();
            LOGGER.debug("data="+data);
            Processor proc = new Processor(Configuration.newConfiguration());
            XsltExecutable exec = proc.newXsltCompiler().compile(new StreamSource(new URL("cp:/generateWholeIndex.xsl").openStream()));
            XsltTransformer transformer = exec.load();
            transformer.setInitialTemplate(new QName(NS,"main"));
            transformer.setParameter(new QName(NS,"programName"), new XdmAtomicValue(projectName));
            transformer.setParameter(new QName(NS, "absoluteRootDir"), new XdmAtomicValue(absoluteRootFolder));
            transformer.setParameter(new QName(NS, "sData"), new XdmAtomicValue(data));
            File ret = new File(new File(outputPath), "entries.xml");
            Serializer serializer = proc.newSerializer(ret);
            transformer.setDestination(serializer);
            transformer.transform();
            return ret;
        } else {
            // here there was nothing to generate, so returns null
            return null;
        }
    }
    
    private static class Triple {
        String label;
        String targetUri;
        String absoluteRootPath;
        int levelsToKeep;
        
        Triple(String label, String targetUri, String absoluteRootPath) {
            super();
            this.label=label;
            this.targetUri=targetUri;
            this.absoluteRootPath=absoluteRootPath;
        }

        @Override
        public String toString() {
            return "label="+label+"\ntargetUri="+targetUri+"\nabsoluteRootFolder="+absoluteRootFolder;
        }
        
        
    }
}
