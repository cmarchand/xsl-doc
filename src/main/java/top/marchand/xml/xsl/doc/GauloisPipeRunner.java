/**
 * This Source Code Form is subject to the terms of 
 * the Mozilla Public License, v. 2.0. If a copy of 
 * the MPL was not distributed with this file, You 
 * can obtain one at https://mozilla.org/MPL/2.0/.
 */
package top.marchand.xml.xsl.doc;

import fr.efl.chaine.xslt.GauloisPipe;
import java.io.IOException;
import java.util.Arrays;

/**
 * Executes the gaulois-pipe instance, and process the index.html file
 * @author cmarchand
 */
public class GauloisPipeRunner {
    public static void main(String[] args) throws IOException {
        String[] gauloisArgs = Arrays.copyOfRange(args, 1, args.length);
        GauloisPipe.main(gauloisArgs);
        // Call the index.html generation
        AccumulatorStep.generateIndex();
    }
}
