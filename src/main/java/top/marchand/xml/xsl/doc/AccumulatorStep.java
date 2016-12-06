/**
 * This Source Code Form is subject to the terms of 
 * the Mozilla Public License, v. 2.0. If a copy of 
 * the MPL was not distributed with this file, You 
 * can obtain one at https://mozilla.org/MPL/2.0/.
 */
package top.marchand.xml.xsl.doc;

import fr.efl.chaine.xslt.StepJava;
import java.io.IOException;
import java.util.HashMap;
import java.util.Stack;
import net.sf.saxon.Configuration;
import net.sf.saxon.event.ProxyReceiver;
import net.sf.saxon.event.Receiver;
import net.sf.saxon.expr.parser.Location;
import net.sf.saxon.om.NodeName;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.SaxonApiException;
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
    private static final Logger LOGGER = LoggerFactory.getLogger(AccumulatorStep.class);
    private static final HashMap<String,CharSequence> inputFiles = new HashMap<>();
    String currentInputFile;
    private static String outputDir;

    @Override
    public Receiver getReceiver(Configuration c) throws SaxonApiException {
        currentInputFile = getParameter(new QName("input-absolute")).toString();
        outputDir = getParameter(new QName("outputFolder")).toString();
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
                    if(nameCode.getLocalPart().equals("indexOutputUri")) {
                        inputFiles.put(currentInputFile, value);
                        LOGGER.debug("[Accumulator] "+currentInputFile+"->"+value);
                    }
                }
            }
        }
    }
    static void generateIndex() throws IOException {
        LOGGER.info("outputDir="+outputDir);
        if(!outputDir.endsWith("/")) outputDir+="/";
        for(String input:inputFiles.keySet()) {
            String relativeUri = inputFiles.get(input).subSequence(outputDir.length(), 1000).toString();
            LOGGER.info(input+" -> "+relativeUri);
        }
    }
}
