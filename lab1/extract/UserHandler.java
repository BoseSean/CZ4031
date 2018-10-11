/**
 * Created by shiganyu on 29/9/18.
 */

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * This SAX parser is able to parse dblp.xml into three files: publictaion.csv, author.csv, and pub_author.csv.
 * <ol>
 * <li>publication.csv</li>
 * This file stores all 7 subclasses of publication. Each row is a publication (pub_id = row number)
 * The columns are all the possible fields for every publication.
 * If a publication does not have a certain field, that column is skipped.
 * <li>author.csv</li>
 * This file contains a list of authors. Each row has two columns: author_id, and author_name
 * <li>pub_author.csv</li>
 * This file has two columns: pub_id and author_name.
 * It stores a many-to-many relationship between publications and authors.
 * </ol>
 */
public class UserHandler extends DefaultHandler {
    private List<String> mPubElements;
    private List<String> mFieldElements;
    private HashMap<String, String> mValues;
    private int mPubId = 0; //unique pubid for each publication
    private int mAuthorId = 0; //unique author_id for each author
    private String mDelimeter = "\t";
    private BufferedWriter mWritePubAuthor;
    private BufferedWriter mWriterPub;
    private BufferedWriter mWriterAuthor;
    private StringBuilder mSb;

    public UserHandler() {
        mSb = new StringBuilder();

        //list of subclasses of publications
        mPubElements = new ArrayList<>();
        mPubElements.add("article");
        mPubElements.add("inproceedings");
        mPubElements.add("proceedings");
        mPubElements.add("book");
        mPubElements.add("incollection");
        mPubElements.add("phdthesis");
        mPubElements.add("masterthesis");
        mPubElements.add("www");

        //list of all possible fields for a publication
        mFieldElements = new ArrayList<>();
        mFieldElements.add("pubid");
        mFieldElements.add("pubtype");
        mFieldElements.add("mdate");
        mFieldElements.add("pubkey");
        mFieldElements.add("booktitle");
        mFieldElements.add("address");
        mFieldElements.add("author");
        mFieldElements.add("cdrom");
        mFieldElements.add("chapter");
        mFieldElements.add("city");
        mFieldElements.add("crossref");
        mFieldElements.add("cite");
        mFieldElements.add("editor");
        mFieldElements.add("ee");
        mFieldElements.add("isbn");
        mFieldElements.add("journal");
        mFieldElements.add("month");
        mFieldElements.add("note");
        mFieldElements.add("number");
        mFieldElements.add("pages");
        mFieldElements.add("publisher");
        mFieldElements.add("publnr");
        mFieldElements.add("school");
        mFieldElements.add("series");
        mFieldElements.add("title");
        mFieldElements.add("url");
        mFieldElements.add("volume");
        mFieldElements.add("year");

        mValues = new HashMap<>();
    }


    /**
     * Handles differently a publication element from a field element.
     * If it is a publication element, all attributes are retrieved.
     * If it is a field element, there is no attribute.
     * @param uri
     * @param localName
     * @param qName
     * @param attributes
     * @throws SAXException
     */
    @Override
    public void startElement(String uri,
                             String localName,
                             String qName,
                             Attributes attributes) throws SAXException {
        qName = qName.toLowerCase();
        if (mPubElements.contains(qName)) {
            String mdate = attributes.getValue("mdate");
            String key = attributes.getValue("key");
            mValues.clear();
            mPubId++;
            mValues.put("pubid", String.valueOf(mPubId));
            mValues.put("pubtype", qName);
            mValues.put("mdate", mdate);
            mValues.put("pubkey", key);

        } else if (mFieldElements.contains(qName)) {
            if (qName.equalsIgnoreCase("author"))
                mAuthorId++;
        }

    }

    /**
     * Handles differently a publication element from a field element.
     * If it is the end of a publication element: insert one entry into "publication.csv"
     * If it is the end of a field element: insert into mValues which stores key-value pairs of all fields.
     * A special case is 'author' element.
     * If it is the end element of 'author' element, we have to insert one entry into 'author.csv' and one entry into 'pub_author.csv'
     * @param uri
     * @param localName
     * @param qName
     * @throws SAXException
     */
    @Override
    public void endElement(String uri,
                           String localName, String qName) throws SAXException {

        qName = qName.toLowerCase();
        if (mPubElements.contains(qName)) {
            writeNewPub(mValues);
        } else if (mFieldElements.contains(qName)) {
            mValues.put(qName, new String(mSb));
            mSb.setLength(0);
            if (qName.equalsIgnoreCase("author")) {
                 writeNewAuthor(mValues.get("author"));
                 writeNewPubAuthor(mValues.get("author"));
            }

        }

    }

    /**
     * Read content between a start element and a end element.
     * Store the characters in a string builder.
     * Handles special characters such as "\"
     * @param ch
     * @param start
     * @param length
     * @throws SAXException
     */
    @Override
    public void characters(char ch[], int start, int length) throws SAXException {
        String str = new String(ch, start, length);
        mSb.append(str.replaceAll("\\\\", ""));
    }

    /**
     * Insert one entry into 'publication.csv'
     * @param values
     */
    private void writeNewPub(HashMap<String, String> values) {

        try {
            mWriterPub = new BufferedWriter(new FileWriter("publication.csv", true));
            for (String field : mFieldElements) {
                if (values.containsKey(field)) {
                    if (mFieldElements.indexOf(field) != 0)
                        mWriterPub.write(mDelimeter);
                    mWriterPub.write(values.get(field));
                } else {
                    mWriterPub.write(mDelimeter);
                }
            }
            mWriterPub.write("\n");
            mWriterPub.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    /**
     * Insert one entry into 'author.csv'
     * @param author
     */
    private void writeNewAuthor(String author) {
        try {
            mWriterAuthor = new BufferedWriter(new FileWriter("author.csv", true));
            mWriterAuthor.write(mAuthorId + mDelimeter + author);
            mWriterAuthor.write("\n");
            mWriterAuthor.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Insert one entry into 'pub_author.csv'
     * @param author
     */
    private void writeNewPubAuthor(String author) {
        try {
            mWritePubAuthor = new BufferedWriter(new FileWriter("pub_author.csv", true));
            mWritePubAuthor.write(mPubId + mDelimeter + author);
            mWritePubAuthor.write("\n");
            mWritePubAuthor.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
