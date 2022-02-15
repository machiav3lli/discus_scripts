import java.util.Calendar;
//import processing.pdf.*; // only if printing a pdf file
import com.cage.zxing4p3.*; // http://cagewebdev.com/zxing4processing-processing-library/

ZXING4P zxing4p;
PFont regular;
PFont bold;
PImage qr_calendar;

int mode;
int modeMargin;

String question;
String webpage;
String reply;
String invitation;
String argumentPositive;
String argumentNegative;

String meetingYear;
String meetingMonth;
String meetingDay;
String meetingHour;
String meetingHourEnd;
String meetingMinute;

boolean hidden = false;

public void settings() {
  try {
    mode = int(args[0]);
  } 
  catch (Exception e) {
    mode = 1;
    modeMargin = 0;
  }
  if (mode != 1) {
    modeMargin = 0;
    size(384, 2070);
    //size(384,2070, PDF, "flyer_"+mode+".pdf");
  } else {
    modeMargin = 250;
    size(384, 2320);
    //size(384,2320, PDF, "flyer_"+mode+".pdf");
  }
}

void setup() {
  background(0);
  zxing4p = new ZXING4P();


  // Create the font
  printArray(PFont.list());
  regular = createFont("DMSans-Regular.ttf", 24);
  bold = createFont("DMSans-Bold.ttf", 24);
  textFont(regular);
  textAlign(CENTER);
  rectMode(CORNERS);

  // Load project's data
  // TODO use an argument to get the files name
  JSONObject json = loadJSONObject("project.json");
  question = json.getString("question", "");
  webpage = json.getString("webpage", "");

  String replyPositive = json.getString("replyPositive", "");
  String replyNeutral = json.getString("replyNeutral", "");
  String replyNegative = json.getString("replyNegative", "");

  JSONArray argumentsPositiveJSON = json.getJSONArray("argumentsPositive");
  argumentPositive = argumentsPositiveJSON.get(int(random(argumentsPositiveJSON.size()))).toString();
  JSONArray argumentsNegativeJSON = json.getJSONArray("argumentsNegative");
  argumentNegative = argumentsNegativeJSON.get(int(random(argumentsNegativeJSON.size()))).toString();
  long meetingDateTime = json.getLong("meetingDateTime", 0);

  Calendar meeting = Calendar.getInstance();
  meeting.setTimeInMillis(meetingDateTime);
  meetingYear = String.format("%04d",meeting.get(Calendar.YEAR));
  meetingMonth = String.format("%02d",meeting.get(Calendar.MONTH) + 1);
  meetingDay = String.format("%02d",meeting.get(Calendar.DAY_OF_MONTH));
  meetingHour = String.format("%02d",meeting.get(Calendar.HOUR_OF_DAY)); // gets hour in 24h format
  //meetingHour = String.format("%02d",calendar.get(Calendar.HOUR)); // gets hour in 12h format
  meetingHourEnd = String.format("%02d",meeting.get(Calendar.HOUR_OF_DAY)+2); // For now the end date is set statically 2 hours after the start
  meetingMinute = String.format("%02d",meeting.get(Calendar.MINUTE));
  // NICE_TO_HAVE: More precise information about the event from JSON e.g. end date, address.
  invitation = json.getString("invitation", "");

  switch (mode) {
  case 0:
    reply = replyPositive;
    break;
  case 2:
    reply = replyNegative;
    break;
  default: // 1
    reply = replyNeutral;
    break;
  }
  
  // Load the QR-Code
  try {
    // Create the QR-Code using ZXing4Processing
    String calendarEventString = "BEGIN:VEVENT"+"\nSUMMARY:"+question+"\nLOCATION:\n"+"URL:"+"\nDESCRIPTION:"+"\nDTSTART:"+meetingYear+meetingMonth+meetingDay+"T"+meetingHour+meetingMinute+"00\nDTEND:"+meetingYear+meetingMonth+meetingDay+"T"+meetingHour+meetingMinute+"00\nBEGIN:VALARM"+"\nTRIGGER:-PT1H"+"\nACTION:DISPLAY"+"\nEND:VALARM"+"\nEND:VEVENT\n";
    qr_calendar = zxing4p.generateQRCode(calendarEventString, 340, 340);
    qr_calendar.save(dataPath("")+"/qrcode_calendar.png"); //<>//
    qr_calendar = loadImage("qrcode_calendar.png");
  } catch (Exception e) {
    // Read the pre-created QR-Code
    //println("Exception: "+e);
    //qr_calendar = loadImage(dataPath("")+"/qrcode_calendar.png");
  }
  

  // So the code run only once
  noLoop();
  noClip();
}

void draw() {
  if (hidden) {
    surface.setVisible(false);
    hidden = true;
  }

  background(255);
  fill(0);
  rectMode(CORNERS);

  textFont(bold);
  textSize(48);
  textAlign(CENTER, CENTER);
  text(question, 4, 0, 380, 400);
  textFont(regular);
  textSize(26);
  strokeCap(ROUND);
  strokeWeight(2);
  line(12, 450, 372, 450);
  text(reply, 20, 460, 364, 700);
  textFont(bold);
  textSize(30);
  if (mode != 1) { // TODO handle neutral option size differences
    text(argumentPositive, 30, 700, 364, 950);
    line(12, 950, 372, 950);
    line(12, 950, 12, 450);
    line(372, 950, 372, 450);
  } else {
    text(argumentPositive, 20, 700, 364, 950);
    line(48, 950, 336, 950);
    text(argumentNegative, 20, 950, 364, 1200);
    line(12, 1200, 372, 1200);
    line(12, 1200, 12, 450);
    line(372, 1200, 372, 450);
  }
  textFont(regular);
  textSize(26);
  textAlign(LEFT);
  text("Erfahre mehr über das Projekt und komme in den Austausch mit anderen Bürgerinnen und Bürgern auf mein.berlin: " + webpage, 12, 1000+modeMargin, 372, 1300+modeMargin);
  textFont(bold);
  textSize(28);
  textAlign(CENTER, BOTTOM);
  text(invitation, 10, 1310+modeMargin, 374, 1730+modeMargin);
  rectMode(CORNER);
  image(qr_calendar, 22, 1730+modeMargin, 340, 340);
  

  save("flyer_"+mode+".png");
  exit();
}
