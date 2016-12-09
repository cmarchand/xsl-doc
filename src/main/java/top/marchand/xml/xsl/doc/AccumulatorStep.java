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
import java.util.HashMap;
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
 * This class accumulates the files that are processed, and on termination,
 * generates a index.html.
 * 
 * @author cmarchand
 */
public class AccumulatorStep extends StepJava {
    public static final String NS = "top:marchand:xml:xsl:doc";
    private static final Logger LOGGER = LoggerFactory.getLogger(AccumulatorStep.class);
    private static final HashMap<String,CharSequence> inputFiles = new HashMap<>();
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
                        inputFiles.put(currentInputFile, value);
                        LOGGER.debug("[Accumulator] "+currentInputFile+"->"+value);
                    }
                }
            }
        }
    }
    static void generateIndex(String projectName) throws IOException, SaxonApiException, URISyntaxException {
        // we do not work with absolute anymore, only relatives
        String outputPath = new File(new URI(outputDir)).getAbsolutePath();
        String absoluteRootPath = new File(new URI(absoluteRootFolder)).getAbsolutePath();
        StringBuilder sb = new StringBuilder();
        for(String input:inputFiles.keySet()) {
            String targetReadUri = new File(new URI(inputFiles.get(input).toString())).getAbsolutePath();
            String targetUri = targetReadUri.subSequence(outputPath.length()+1, targetReadUri.length()).toString();
            String sourceUri = input.substring(absoluteRootPath.length()+1);
            sb.append(sourceUri).append("@").append(targetUri).append("|");
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
        Serializer serializer = proc.newSerializer(new File(new File(outputPath), "entries.xml"));
        transformer.setDestination(serializer);
        transformer.transform();
    }
}
