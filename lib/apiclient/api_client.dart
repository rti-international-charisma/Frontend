import 'dart:io';

import 'package:http/http.dart';

import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Client _client;
  final String _baseUrl;
  final Map<String, String> _headers;

  ApiClient(this._client, this._baseUrl) : _headers = {};
  ApiClient._(this._client, this._baseUrl, this._headers);

  Future<T>? get<T>(String path) async {
    var api = _baseUrl.endsWith("/")
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    var processedPath = path.startsWith("/") ? path : "/$path";
    print("Path: $api$processedPath");
    var response = await _client
        .get(Uri.parse("$api$processedPath"), headers: {..._headers});
    // print("$path : ${response.statusCode}");
    // print("Response : ${response.body}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return convert.jsonDecode(response.body) as T;
    }
    print(response.body);
    throw ErrorBody(response.statusCode, convert.jsonDecode(response.body));
  }

  Future<T>? getCounsellingModule<T>() async {
    return convert.jsonDecode(counsellingModuleJson);
  }

  Future<T>? post<T>(String path, Map<String, dynamic> body) async {
    var api = _baseUrl.endsWith("/")
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    var processedPath = path.startsWith("/") ? path : "/$path";
    print("Path: $api$processedPath Body:$body");
    var response = await _client.post(Uri.parse("$api$processedPath"),
        headers: {"Content-Type": ContentType.json.mimeType, ..._headers},
        body: convert.jsonEncode(body));
    print("$path : ${response.statusCode}");
    print("Response : ${response.body}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return (response.body.isEmpty
          ? response.body
          : convert.jsonDecode(response.body)) as T;
    }

    throw ErrorBody(response.statusCode, convert.jsonDecode(response.body));
  }

  Future<T>? postWithHeaders<T>(String path, Map<String, dynamic> body, Map<String, String> headers) async {
    var api = _baseUrl.endsWith("/")
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    var processedPath = path.startsWith("/") ? path : "/$path";
    print("Path: $api$processedPath Body");
    var response = await _client.post(Uri.parse("$api$processedPath"),
        headers: {"Content-Type": ContentType.json.mimeType, ...headers},
        body: convert.jsonEncode(body));
    print("$path : ${response.statusCode}");
    print("Response : ${response.body}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return (response.body.isEmpty
          ? response.body
          : convert.jsonDecode(response.body)) as T;
    }

    print("Response : Throwing error");
    throw ErrorBody(response.statusCode, convert.jsonDecode(response.body));
  }

  Future<T>? getUserData<T>() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userDataEncoded = prefs.getString('userData');

    if (userDataEncoded == null) {
      return Map() as T;
    } else {
      return convert.jsonDecode(userDataEncoded)['user'] as T;
    }
  }

  ApiClient withAdditionalHeaders(Map<String, String> headers) {
    return ApiClient._(_client, _baseUrl, headers);
  }
}

class ErrorBody {
  int? code;
  Map<String, dynamic> body;

  ErrorBody(this.code, this.body);
}

var counsellingModuleJson =
    "{\"score\":{\"sections\":[{\"sectionId\":\"c8aca8b8-d22e-4291-b60e-08a878dac42a\",\"sectionType\":\"PARTNER CONTEXT\",\"questions\":[{\"questionId\":\"53e79da3-d07a-4f13-81af-b09170a52360\",\"score\":2},{\"questionId\":\"d33111eb-96fb-4a74-8162-dea5850ed4ee\",\"score\":2},{\"questionId\":\"1d369bb8-8373-4010-968b-313c11fa1af6\",\"score\":1}]},{\"sectionId\":\"3a9be2a0-ea29-40ee-973c-d183af87996f\",\"sectionType\":\"TRADITIONAL VALUES\",\"questions\":[{\"questionId\":\"61241d26-3afb-47b7-97ce-46df9c1c42bd\",\"score\":1},{\"questionId\":\"0008ea62-937a-4dcb-9b01-5e145d82abbd\",\"score\":4}]},{\"sectionId\":\"d4dc8750-6364-4278-9c2d-2d594347cc7a\",\"sectionType\":\"PARTNER ABUSE AND CONTROL\",\"questions\":[{\"questionId\":\"e2a0f3be-c756-481e-8ac4-9be8fa515708\",\"score\":2},{\"questionId\":\"ac4a70e8-aa40-4ffa-8769-984842d67e95\",\"score\":1}]},{\"sectionId\":\"fafcdc7a-4be6-4cf3-82e5-9ddde66479bf\",\"sectionType\":\"PARTNER SUPPORT\",\"questions\":[{\"questionId\":\"15aa0bd9-2022-406f-a6b6-8bc1d70044e7\",\"score\":2},{\"questionId\":\"cabf12cb-4eea-484d-b6c7-f117f0550287\",\"score\":2}]},{\"sectionId\":\"b4399697-2e38-434b-9e07-94242bb91295\",\"sectionType\":\"PARTNER ATTITUDE TO HIV PREVENTION\",\"questions\":[{\"questionId\":\"b3454076-f0c7-4f8e-9f4e-89e3997ec6da\",\"score\":2}]},{\"sectionId\":\"746ad99f-0ded-4fc9-95a3-162ebe94d616\",\"sectionType\":\"HIV PREVENTION READINESS\",\"questions\":[{\"questionId\":\"bedd6c69-459d-4d4e-b017-46fab6b7c7e4\",\"score\":6},{\"questionId\":\"916eaa5a-9431-442a-9119-1efb5375b835\",\"score\":6},{\"questionId\":\"f8af8cb5-7707-4be3-af2a-316ac1143096\",\"score\":6}]}]},\"module\":{\"id\":\"prep-use\",\"title\":\"Discussing PrEP Use With Partners\",\"introduction\":\"<p>Bring about positive changes in your relationship through better communication</p>\",\"heroImage\":{\"title\":\"Pr Ep Hero Image\",\"imageUrl\":\"/assets/1c2eea87-f593-41c2-b6ba-da69a3133c9a\"},\"counsellinModuleSections\":[{\"id\":\"section_4\",\"title\":\"How to use PrEP without anyone knowing\",\"introduction\":\"<p>Sometimes it makes sense not to tell your partner, or anyone else about your PrEP use, if you think<br />they&rsquo;ll be violent towards you or have another reaction that would be hard to handle. If you don&rsquo;t<br />want to tell them, that&rsquo;s your choice, but it&rsquo;s good to think about how to keep your PrEP use a<br />secret.</p>\",\"summary\":null,\"accordionContent\":[{\"id\":\"section_4_accordion_1\",\"title\":\"Here are some tips that other young women have used:\",\"description\":\"<p>● Store pills in places your partner, or loved ones will not look, such as a handbag, a keychain with storage, or with pads and tampons.<br />● Ask a neighbour or a nearby friend to keep the pills, although this can make it challenging to remember to take them every day.<br />● Store a few doses in an unmarked container (ensure that this container is not clear plastic because sun can damage medication).<br />● If your partner or loved one monitors or watches you closely, think of a reason for the regular clinic visits. For e.g. you could tell them you&rsquo;re going to the clinic for a medical condition. You can also tell them you&rsquo;re taking this medication for another reason such as pregnancy prevention or menstrual cramps.</p>\"}]},{\"id\":\"section_5\",\"title\":\"Why you decided to use oral PrEP\",\"introduction\":\"<p>If talking to a partner, the benefits for the relationship, and how PrEP will affect your sexual<br />behaviours in the relationship, and other prevention behaviours (like condom use)</p>\",\"summary\":null,\"accordionContent\":null},{\"id\":\"section_1\",\"title\":\"Should I tell my partner, or someone else I love, I’m taking PrEP?\",\"introduction\":\"<p><em>There are many things that other women like you think about when deciding whether to tell reasons</em><br /><em>that women do and don&rsquo;t tell their partners, or someone they love, about their use of oral PrEP. It can</em><br /><em>be helpful for some young women to have their partner&rsquo;s support, but it&rsquo;s important to think about</em><br /><em>your own reasons for telling them. What are some reasons that you might want to tell your partner,</em><br /><em>or someone you love, about PrEP?</em></p>\",\"summary\":\"<p>Remember, whether you share or not is optional. It&rsquo;s your decision whether to talk to your partner,<br />or someone else, about PrEP use.</p>\\\\n<p><br /><strong>Do you think it would be helpful to tell your partner, or someone else, that you&rsquo;re using PrEP?</strong><br />● How do you think they would react?<br />● Why did or would you tell him?<br />● Why didn&rsquo;t or wouldn&rsquo;t you tell him?</p>\",\"accordionContent\":[{\"id\":\"section_1_accordion_1\",\"title\":\"Some common reasons for sharing are:\",\"description\":\"<p>● You feel like you need your partner&rsquo;s, or someone&rsquo;s, permission to take PrEP<br />● You like to make decisions with your partner, because you &lsquo;share everything&rsquo;<br />● You want their support and encouragement for your decision to use PrEP<br />● You think someone can help your adherence by helping you remember to take PrEP successfully, by reminding you to take your daily pill and get refills when needed<br />● You worry your partner, or someone else, would be more upset if they found out you were using PrEP without her telling them<br />● You don&rsquo;t want your partner to have misconceptions or misunderstandings about oral PrEP (e.g. Such as think they&rsquo;re it&rsquo;s using a muti or ARVs for HIV-positive people)</p>\"},{\"id\":\"section_1_accordion_2\",\"title\":\"On the other hand, some reasons for NOT sharing include:\",\"description\":\"<p>● You worry your partner, or someone else you tell, may not allow you to use PrEP or force you to stop using it<br />● You worry they may not be supportive, and will think you don&rsquo;t trust them<br />● You worry that your partner may think you are sleeping around and that they will not trust you<br />● Your partner might think that PrEP is ARVs, and that you are actually HIV positive<br />● You worry your partner may start or continue sleeping around because he thinks you&rsquo;re protected or he&rsquo;s protected by your PrEP use<br />● You worry your partner may be violent<br />● You fear your partner may end the relationship or you&rsquo;ll be kicked out of your home<br />● You don&rsquo;t feel the need to share the decision with your partner or anyone else. It&rsquo;s your own body and your decision</p>\"}]},{\"id\":\"section_2\",\"title\":\"How to tell your partner, or someone else you trust, about PrEP…\",\"introduction\":\"<p>It can sometimes be difficult to bring up the issue of HIV prevention with a partner, but there are ways it can become easier.</p>\",\"summary\":null,\"accordionContent\":[{\"id\":\"section_2_accordion_2\",\"title\":\"Where to tell someone\",\"description\":\"<p>● Do it in a comfortable and private place where no one will overhear you and where you will not be interrupted.</p>\\\\n<p>● If you are worried that he may be violent or you are not sure how he will react, don&rsquo;t be too far away from others so that you can get help if you need it.<br />● When to tell someone<br />● When you will have enough time to say everything you need to say<br />● When you will have enough time for that person to respond and ask questions<br />● When both of you are in a good mood and with a settled mind<br />● If you are worried that he may become violent, it may help to disclose during the daytime so you can get help more easily, if you need it.</p>\"},{\"id\":\"section_2_accordion_1\",\"title\":\"Here are some tips you can use to make it easier:\",\"description\":\"<p>● How to tell someone<br />● Use clear and simple language.<br />● Maintain eye contact, remain confident and calm.<br />● Have prepared answers for anticipated questions<br />● Start disclosure indirectly by creating a story talking about PrEP in general without telling him you&rsquo;re using it and see what he says. If he says negative things, you may not want to tell him you are using it. Gauge his reaction; if you feel he may harm you, do not disclose.<br />● Be prepared to answer his questions.<br />● Listen openly to your partner&rsquo;s concerns do not assume you already know what he is going to say.<br />● Avoid blaming others when disclosing, especially him. In other words, don&rsquo;t say that it is his fault that you are using PrEP, because of his behaviours. Instead, say it is your decision to protect yourself.<br />● Observe or Look at your partner&rsquo;s the body language of your partner as you are disclosing or talking to him about PrEP to see his reaction.<br />● Be sensitive to emotions and feelings of your partner as you are disclosing or talking to him.</p>\"}]},{\"id\":\"section_3\",\"title\":\"What if my partner, or loved one, has a bad reaction?\",\"introduction\":\"<p>Many people do have misconceptions about PrEP so it&rsquo;s important to be ready with your response.<br />Let&rsquo;s talk about some potential ways your partner, or someone else you tell, might respond if you<br />told them about PrEP. It can be helpful if you have someone in your life to support you, but not<br />everyone reacts positively. Remember, it&rsquo;s your choice whether to talk about your PrEP use, or not.<br />However, it can be helpful if you have someone in your life to support you.</p>\",\"summary\":null,\"accordionContent\":null}],\"counsellingModuleActionPoints\":[{\"id\":\"model_prep_use_action_point_1\",\"title\":\"Make a decision about whether to tell my partner about PrEP or not\"},{\"id\":\"model_prep_use_action_point_2\",\"title\":\"Practice how I’ll respond to my partner’s concerns about PrEP\"},{\"id\":\"model_prep_use_action_point_3\",\"title\":\"Prepare for telling my partner (e.g. decide where and when I’ll do it)\"},{\"id\":\"model_prep_use_action_point_4\",\"title\":\"Share materials from this site with my partner\"},{\"id\":\"model_prep_use_action_point_5\",\"title\":\"Call a PrEP clinic to ask about partner counselling\"},{\"id\":\"model_prep_use_action_point_6\",\"title\":\"Make a plan to keep my PrEP secret (e.g. where to store it and when to take it)\"}]}}";
