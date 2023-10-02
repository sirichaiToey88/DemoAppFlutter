Open Food Facts API:

Endpoint: https://world.openfoodfacts.org/
Description: Open Food Facts is a collaborative database of food products from around the world. It provides detailed information about ingredients, nutritional values, and more.
Example Request: https://world.openfoodfacts.org/api/v0/product/737628064502.json
Fake Store API:

Endpoint: https://fakestoreapi.com/
Description: Fake Store API provides mock data for an online store, including product categories, products, and user information.
Example Request: https://fakestoreapi.com/products
Walmart Open API:

Endpoint: https://developer.walmart.com/
Description: Walmart Open API allows access to a wide range of Walmart's product catalog, pricing information, and other related data.
Example Request: https://developer.api.walmart.com/api-proxy/service/affil/product/v2/items
Best Buy API:

Endpoint: https://developer.bestbuy.com/
Description: Best Buy API provides access to Best Buy's product catalog, including information about products, pricing, availability, and more.
Example Request: https://api.bestbuy.com/v1/products((categoryPath.id=abcat0502000))?apiKey=YOUR_API_KEY
JSONPlaceholder:

Endpoint: https://jsonplaceholder.typicode.com/
Description: JSONPlaceholder is a fake online REST API that provides placeholder data, including products, posts, comments, and more, for testing and prototyping purposes.
Example Request: https://jsonplaceholder.typicode.com/posts

การใช้โค้ดดังกล่าวเป็นเทคนิคที่ใช้ใน Dart เพื่อแปลงข้อมูล JSON ที่ได้รับจากแหล่งข้อมูลส่งคืนมาจากเซิร์ฟเวอร์ให้กลายเป็นออบเจ็กต์ของคลาสใน Dart โดยตรงและสามารถเข้าถึงข้อมูลที่ได้กลายเป็นออบเจ็กต์นั้นได้อย่างง่ายดายและปลอดภัย

ในที่นี้เรามีการกระทำต่อไปนี้:

List<dynamic> responseData = response.data;: คำสั่งนี้เป็นการเก็บข้อมูล JSON ที่ได้รับมาจากเซิร์ฟเวอร์ในตัวแปร responseData ซึ่งเป็นรายการของออบเจ็กต์ที่มีค่าของประเภท dynamic นั่นคือ ไม่มีการกำหนดประเภทของข้อมูลก่อนเริ่มใช้งาน

responseData.map((json) => ListBookings.fromJson(json)).toList();: คำสั่งนี้ใช้ map() ในการแปลงข้อมูล JSON ทุกตัวใน responseData เป็นออบเจ็กต์ของคลาส ListBookings โดยใช้ ListBookings.fromJson() เป็นเมธอดสร้างใหม่ และต่อมาใช้ toList() เพื่อแปลงผลลัพธ์ที่ได้จาก map() กลับเป็นรายการของออบเจ็กต์ ListBookings ที่เป็นรูปแบบของข้อมูลที่ใช้งานได้ง่ายใน Dart

โดยใช้เทคนิคนี้ คุณจะสามารถแปลงข้อมูล JSON เป็นออบเจ็กต์ของคลาสใน Dart ได้อย่างสะดวกและครอบคลุม ซึ่งช่วยให้การจัดการกับข้อมูลที่ได้รับมาจากเซิร์ฟเวอร์เป็นเรื่องง่าย และเป็นประโยชน์ในการเขียนโค้ดที่เป็นระเบียบและอ่านง่ายมากขึ้น

SendBird (https://sendbird.com/)

SendBird เป็นแพลตฟอร์มที่ให้บริการด้านการส่งข้อความและ Live Chat ที่ใช้งานง่ายและมีความยืดหยุ่นสูง มี SDK สำหรับ Flutter ที่สามารถใช้ในการสร้าง Live Chat ในแอปพลิเคชันของคุณได้ง่ายๆ
Twilio Flex (https://www.twilio.com/flex)

Twilio Flex เป็นแพลตฟอร์มการติดต่อกับลูกค้าที่ให้คุณสร้างและปรับแต่งระบบ Live Chat ได้ตามความต้องการ มี SDK สำหรับ Flutter ที่คุณสามารถใช้ในการเชื่อมต่อและใช้งานกับ Twilio Flex ได้
Applozic (https://www.applozic.com/)

Applozic เป็นแพลตฟอร์มการสร้างแชทที่ให้บริการในรูปแบบ SDK ซึ่งมีฟังก์ชันหลากหลายสำหรับการสร้างแชทในแอปพลิเคชันของคุณ มี SDK สำหรับ Flutter ที่สามารถใช้ในการเชื่อมต่อและสร้าง Live Chat ได้

isEqualTo: เป็นการตรวจสอบว่าค่าในฟิลด์ของเอกสารมีค่าเท่ากับค่าที่กำหนดหรือไม่ ถ้าค่าตรงกันเงื่อนไขใน where นี้จะถูกต้องและเอกสารนั้นจะถูกคืนกลับมา

isNotEqualTo: เป็นการตรวจสอบว่าค่าในฟิลด์ของเอกสารไม่เท่ากับค่าที่กำหนด ถ้าค่าไม่ตรงกันเงื่อนไขใน where นี้จะถูกต้องและเอกสารนั้นจะถูกคืนกลับมา

isLessThan: เป็นการตรวจสอบว่าค่าในฟิลด์ของเอกสารน้อยกว่าค่าที่กำหนด ถ้าค่าน้อยกว่าเงื่อนไขใน where นี้จะถูกต้องและเอกสารนั้นจะถูกคืนกลับมา

isLessThanOrEqualTo: เป็นการตรวจสอบว่าค่าในฟิลด์ของเอกสารน้อยกว่าหรือเท่ากับค่าที่กำหนด ถ้าค่าน้อยกว่าหรือเท่ากับเงื่อนไขใน where นี้จะถูกต้องและเอกสารนั้นจะถูกคืนกลับมา

isGreaterThan: เป็นการตรวจสอบว่าค่าในฟิลด์ของเอกสารมากกว่าค่าที่กำหนด ถ้าค่ามากกว่าเงื่อนไขใน where นี้จะถูกต้องและเอกสารนั้นจะถูกคืนกลับมา

isGreaterThanOrEqualTo: เป็นการตรวจสอบว่าค่าในฟิลด์ของเอกสารมากกว่าหรือเท่ากับค่าที่กำหนด ถ้าค่ามากกว่าหรือเท่ากับเงื่อนไขใน where นี้จะถูกต้องและเอกสารนั้นจะถูกคืนกลับมา

arrayContains: เป็นการตรวจสอบว่าค่าที่กำหนดอยู่ในอาร์เรย์ของเอกสารหรือไม่ ถ้าค่าอยู่ในอาร์เรย์เงื่อนไขใน where นี้จะถูกต้องและเอกสารนั้นจะถูกคืนกลับมา

arrayContainsAny: เป็นการตรวจสอบว่าค่าในอาร์เรย์ของเอกสารมีค่าในอาร์เรย์ที่กำหนดอยู่หรือไม่ ถ้าค่าในอาร์เรย์ตรงกับค่าในอาร์เรย์ในเงื่อนไขใน where นี้จะถูกต้องและเอกสารนั้นจะถูกคืนกลับมา

whereIn: เป็นการตรวจสอบว่าค่าในฟิลด์ของเอกสารอยู่ในอาร์เรย์ที่กำหนดหรือไม่ ถ้าค่าอยู่ในอาร์เรย์เงื่อนไขใน where นี้จะถูกต้องและเอกสารนั

Dialogflow ES (Essentials): Dialogflow เปิดให้บริการแบบ Essentials ที่ไม่มีค่าใช้จ่าย ซึ่งมีความสามารถในการทำ NLP และส่งคำถามไปยัง Chat Bot ของคุณ คุณจะต้องสร้างบัญชีผู้ใช้ใน Dialogflow เพื่อใช้งานบริการนี้ สำหรับระบบ Speech Recognition คุณอาจใช้ Speech Recognition API ของ Google Cloud Platform ซึ่งมีส่วนที่ให้บริการฟรี

Rasa: Rasa เป็น Open Source NLP Framework ที่มีความสามารถในการสร้างและสนับสนุน Chat Bot ที่มีความฉลาดในการตอบคำถามของผู้ใช้ คุณสามารถใช้ Rasa ในการสร้าง Chat Bot และการทำ NLP ของแอปพลิเคชันของคุณ

Tensorflow: หากคุณมีความถนัดในการเขียนโค้ดและต้องการสร้าง NLP และ Speech Recognition ของตัวเอง คุณอาจใช้ Tensorflow ในการสร้างโมเดลและตรวจจับเสียงของ Chat Bot ที่คุณต้องการ

Navigator.pushAndRemoveUntil(
context,
MaterialPageRoute(
builder: (context) => HomeUser(
fullName: snapshot.docs[0]['fullName'],
userEmail: \_emailController.text,
),
),
(route) => false,
);

Navigator.pushAndRemoveUntil(
context,
MaterialPageRoute(builder: (context) => const HomeUser()),
(route) => false, // ลบทุกหน้าใน stack และให้หน้า HomeUser เป็นหน้าแรก
);


flutter run -d <device_id_1>,<device_id_2> --hot

void main() {
  String data = 'ElmaBATmi5hShtT9S6Mm36bHXTj1_jiradech saardnuam';
  List<String> parts = data.split('_');

  if (parts.length > 1) {
    String result = parts[1];
    print(result); // แสดงผลข้อความหลัง _
  } else {
    print('ไม่พบตัวอักษร _ ในข้อความ');
  }
}