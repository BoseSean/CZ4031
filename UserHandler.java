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
import java.util.Map;

public class UserHandler extends DefaultHandler {
    private List<String> mElements;
    private List<String> mFields;
    private HashMap<String, String> mValues;
    private Map<String, Boolean> isProcessingMap;
    private int mCount = 0;
    private int mAuthorCount = 0;
    String mDelimeter = "\t";


    public UserHandler() {

        mElements = new ArrayList<>();
        mElements.add("article");
        mElements.add("inproceedings");
        mElements.add("proceedings");
        mElements.add("book");
        mElements.add("incollection");
        mElements.add("phdthesis");
        mElements.add("masterthesis");
        mElements.add("www");


        mFields = new ArrayList<>();
        mFields.add("pubid");
        mFields.add("pubtype");
        mFields.add("mdate");
        mFields.add("pubkey");
        mFields.add("author");
        mFields.add("booktitle");
        mFields.add("address");
        mFields.add("cdrom");
        mFields.add("chapter");
        mFields.add("city");
        mFields.add("crossref");
        mFields.add("cite");
        mFields.add("editor");
        mFields.add("ee");
        mFields.add("isbn");
        mFields.add("journal");
        mFields.add("month");
        mFields.add("note");
        mFields.add("number");
        mFields.add("pages");
        mFields.add("publisher");
        mFields.add("publnr");
        mFields.add("school");
        mFields.add("series");
        mFields.add("title");
        mFields.add("url");
        mFields.add("volume");
        mFields.add("year");
        mFields.add("incollection");



        isProcessingMap = new HashMap<>();
        for (String field: mFields) {
            isProcessingMap.put(field, false);
        }

        mValues = new HashMap<>();
        for (String field : mFields) {
            mValues.put(field,field);
        }

//        writeNewPub(mValues);

    }

    @Override
    public void startElement(String uri,
                             String localName,
                             String qName,
                             Attributes attributes) throws SAXException {


        qName = qName.toLowerCase();
        if (mElements.contains(qName)) {
            String mdate = attributes.getValue("mdate");
            String key = attributes.getValue("key");
            mValues.clear();
            mCount ++;
            mValues.put("pubid", String.valueOf(mCount));
            mValues.put("pubtype", qName);
            mValues.put("mdate", mdate);
            mValues.put("key", key);
            mValues.put("incollection", getCollection(key));

        } else if (mFields.contains(qName)) {
            isProcessingMap.put(qName, true);

            if (qName.equalsIgnoreCase("author"))
                mAuthorCount ++;
        }

    }

    private String getCollection(String key) {
        String[] parts = key.split("/");
        if (parts.length > 0)
            return parts[0];
        return null;
    }

    @Override
    public void endElement(String uri,
                           String localName, String qName) throws SAXException {
        qName = qName.toLowerCase();
        if (mElements.contains(qName)) {
//            switch(qName){
//                case("article"):
//                    break;
//                case("inproceedings"):
//                    break;
//                case("proceedings"):
//                    break;
//                case("book"):
//                    break;
//                case("incollection"):
//                    break;
//                case("phdthesis"):
//                    break;
//                case("masterthesis"):
//                    break;
//                case("www"):
//                    break;
//            }
//            writeNewPub(mValues);
        } else if (qName.equalsIgnoreCase("author")) {
//            writeNewAuthor(mValues.get("author"));
            writeNewPubAuthor(mValues.get("author"));

        }
    }

    private void writeNewPubAuthor(String author) {
        try {
            BufferedWriter writer = new BufferedWriter(new FileWriter("pub_author.txt", true));
            writer.write(mCount + mDelimeter + author);
            writer.write("\n");
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void writeNewAuthor(String author) {
        try {
            BufferedWriter writer = new BufferedWriter(new FileWriter("author.txt", true));
            writer.write(mAuthorCount + mDelimeter + author);
            writer.write("\n");
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void writeNewPub(HashMap<String, String> values) {

//        if (!mValues.get("key").startsWith("conf/vldb"))
//            return;
        try {
            BufferedWriter writer = new BufferedWriter(new FileWriter("pub.txt", true));
            for (String field : mFields) {
                if (values.containsKey(field)) {
//                    System.out.print(mValues.get(field) + mDelimeter);
                    if (mFields.indexOf(field) != 0)
                        writer.write(mDelimeter);
                    writer.write(values.get(field));
                } else {
//                    System.out.print(mDelimeter);
                    writer.write(mDelimeter);
                }
            }
//            System.out.println();
            writer.write("\n");
            writer.close();
            if (mCount % 100 == 0) {
//                System.out.println("Count: " + mCount );
//                total: 6456500
            }
            } catch (IOException e) {
                e.printStackTrace();
        }

    }

    @Override
    public void characters(char ch[], int start, int length) throws SAXException {
        for (Map.Entry<String, Boolean> entry : isProcessingMap.entrySet()) {
            Boolean isProcessing = entry.getValue();
            if (isProcessing) {
                String field = entry.getKey();
                mValues.put(field, new String(ch, start, length));
                isProcessingMap.put(field, false);
                break;
            }
        }
    }
}
