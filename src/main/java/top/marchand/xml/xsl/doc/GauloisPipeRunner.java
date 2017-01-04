/**
 * This Source Code Form is subject to the terms of 
 * the Mozilla Public License, v. 2.0. If a copy of 
 * the MPL was not distributed with this file, You 
 * can obtain one at https://mozilla.org/MPL/2.0/.
 */
package top.marchand.xml.xsl.doc;

import fr.efl.chaine.xslt.GauloisPipe;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.charset.Charset;
import java.util.Arrays;
import net.sf.saxon.s9api.SaxonApiException;

/**
 * Executes the gaulois-pipe instance, and process the index.html file
 * @author cmarchand
 */
public class GauloisPipeRunner {
    public static void main(String[] args) throws IOException, SaxonApiException, URISyntaxException {
        String[] gauloisArgs = Arrays.copyOfRange(args, 2, args.length);
        String projectName = args[1];
        // TODO : add this as a parameter
        GauloisPipe.main(gauloisArgs);
        // Call the index.html generation
        File indexFile = AccumulatorStep.generateIndex(projectName);
        if(indexFile==null) {
            String s = args[args.length-1];
            String sOutputFolder = s.substring("outputFolder=".length());
            // outputFolder is a URI
            File outputFolder = new File(new URI(sOutputFolder));
            // in this particular case, src/site/target/xsldoc may have not been created
            boolean ret = outputFolder.mkdirs();
            if(!ret) {
                System.err.println("[ERROR] not able to create "+outputFolder.getAbsolutePath()+" directory");
            }
            File entriesFile = new File(outputFolder,"entries.xml");
            try (PrintWriter writer = new PrintWriter(entriesFile,Charset.forName("UTF-8").name())) {
                writer.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<entries/>");
                writer.flush();
            }
        }
    }
}
