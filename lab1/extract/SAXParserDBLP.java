import javax.xml.parsers.SAXParserFactory;
import java.io.File;

/**
 * Created by shiganyu on 29/9/18.
 */

public class SAXParserDBLP {

    public static void main(String[] args) {

        try {
            File inputFile = new File("dblp.xml");
            SAXParserFactory factory = SAXParserFactory.newInstance();
            javax.xml.parsers.SAXParser saxParser = factory.newSAXParser();
            UserHandler userhandler = new UserHandler();
            saxParser.parse(inputFile, userhandler);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
