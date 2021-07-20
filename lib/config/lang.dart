import 'package:flutter/material.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/pref.dart';

import 'language/langDeu.dart';
import 'language/langArabic.dart';
import 'language/langEsp.dart';
import 'language/langFrench.dart';
import 'language/langKorean.dart';
import 'language/langPort.dart';
import 'language/langRus.dart';

class LangData{
  String name;
  String engName;
  String image;
  bool current;
  int id;
  TextDirection direction;
  LangData({this.name, this.engName, this.image, this.current, this.id, this.direction});
}

class Lang {

  static var english = 1;
  static var german = 2;
  static var espanol = 3;
  static var french = 4;
  static var korean = 5;
  static var arabic = 6;
  static var portugal = 7;
  static var rus = 8;

  var direction = TextDirection.ltr;

  List<LangData> langData = [
    LangData(name: "English", engName: "English", image: "assets/usa.png", current: false, id: english, direction: TextDirection.ltr),
    LangData(name: "Deutsh", engName: "German", image: "assets/ger.png", current: false, id: german, direction: TextDirection.ltr),
    LangData(name: "Spana", engName: "Spanish", image: "assets/esp.png", current: false, id: espanol, direction: TextDirection.ltr),
    LangData(name: "Français", engName: "French", image: "assets/fra.png", current: false, id: french, direction: TextDirection.ltr),
    LangData(name: "한국어", engName: "Korean", image: "assets/kor.png", current: false, id: korean, direction: TextDirection.ltr),
    LangData(name: "عربى", engName: "Arabic", image: "assets/arabic.png", current: false, id: arabic, direction: TextDirection.rtl),
    LangData(name: "Português", engName: "Portuguese", image: "assets/portugal.png", current: false, id: portugal, direction: TextDirection.ltr),
    LangData(name: "Русский", engName: "Russian", image: "assets/rus.jpg", current: false, id: rus, direction: TextDirection.ltr),
  ];

  Map<int, String> langEng = {
    10 : "Vendor Markets",
    82 : "You can add to cart, only products from single market. Do you want to reset cart? And add new product.",
    142 : "Enjoying Market?",
    143 : "How would you rate this Market?",
    200 : "Top Markets this week",
    247 : "Pickup from market",
    259 : "The Market: ",
    267 : "Market",

    15 : "Login",
    16 : "Password",
    17 : "Forgot password",
    18 : "Continue",
    19 : "Don't have an account? Create",
    20 : "Forgot password",
    21 : "E-mail address",
    22 : "LOGIN",
    23 : "SEND",
    24 : "Create an Account!",
    25 : "Confirm Password",
    26 : "CREATE ACCOUNT",
    27 : "To continue enter your phone number",
    28 : "Phone number",
    29 : "CONTINUE",
    30 : "Verify phone number",
    33 : "Home",
    34 : "Search",
    35 : "Notifications",
    36 : "My Orders",
    37 : "Account",
    38 : "Favorites",
    39 : "Near Your",
    42 : "Most Popular",
    43 : "Recent Reviews",
    44 : "Not Have Notifications",
    45 : "Notifications",
    46 : "This is very important information",
    47 : "Map",
    48 : "Address",
    51 : "Help & support",
    57 : "Username",
    58 : "E-mail",
    62 : "Languages",
    63 : "App Language",
    69 : "Information",
    70 : "Monday",
    71 : "Tuesday",
    72 : "Wednesday",
    73 : "Thursday",
    74 : "Friday",
    75 : "Saturday",
    76 : "Sunday",
    77 : "Reviews",
    79 : "Ingredients",
    80 : "Nutrition",
    81 : "Mobile Phone",
    83 : "Reset",
    84 : "Cancel",
    85 : "Comments",
    86 : "There is no item in your cart",
    87 : "Check out our new items and update your collection",
    88 : "Continue Shopping",
    89 : "Extras",
    90 : "Add to cart",
    91 : "Products",
    93 : "Subtotal",
    94 : "Shopping costs",
    95 : "Taxes",
    96 : "Total",
    97 : "Checkout",
    98 : "Basket",
    99 : "Shopping Cart",
    100 : "Verify your quantity and click checkout",
    106 : "Phone",
    118 : "Done",
    119 : "My Orders",
    120 : "Order received",
    121 : "Order preparing",
    122 : "Order ready",
    123 : "On the way",
    124 : "Delivery",
    125 : "You must sign-in to access to this section",
    127 : "OK",
    128 : "Something went wrong. ",
    130 : "This product was added to cart",
    131 : "This product already added to cart",
    132 : "Sign Out",
    133 : "All",
    134 : "Passwords are different.",
    135 : "A letter with a new password has been sent to the specified E-mail",
    136 : "User with this Email was not found!",
    137 : "Failed to send Email. Please try again later.\n",
    138 : "Add Review",
    140 : "How would you rate this product?",
    141 : "Enter your review",
    145 : "Change password",
    146 : "Edit Profile",
    147 : "Change password",
    148 : "Old password",
    149 : "Enter your old password",
    150 : "New password",
    152 : "Enter your new password",
    153 : "Confirm New password",
    154 : "Enter your new password",
    155 : "Cancel",
    156 : "Edit profile",
    157 : "User Name",
    158 : "Enter your User Name",
    159 : "E-mail",
    160 : "Enter your User E-mail",
    161 : "Enter your User Phone",
    162 : "Change",
    163 : "Open Gallery",
    164 : "Open Camera",
    166 : "Password change",
    167 : "Passwords don't equals",
    168 : "Old password is incorrect",
    169 : "The password length must be more than 5 chars",
    170 : "Enter New Password",
    171 : "User Profile change",
    172 : "Enter Login",
    173 : "Enter Password",
    174 : "Login or Password in incorrect",
    175 : "Enter your Login",
    176 : "Enter your E-mail",
    177 : "Enter your password",
    178 : "You E-mail is incorrect",
    179 : "Not Have Favorites Products",
    180 : "Not Have Orders",
    181 : "Select place on map or find address on Search",
    182 : "Delivery Address:",
    183 : "no address",
    184 : "Select Address",
    185 : "Enter Phone number",
    186 : "Enter Comments",
    188 : "Payment",
    189 : "Cash on delivery",
    191 : "Razorpay",
    192 : "Visa, Mastercard",
    194 : "All transactions are secure and encrypted.",
    195 : "Id #",
    196 : "Cancelled",
    197 : "and",
    198 : "items",
    199 : "Top on this week",
    201 : "I will take the products myself",
    202 : "When your order will be ready, you will receive a message: \"Your Order was Ready\". Then "
        "when you arrive at the pickup location open application. Open \"My Orders\" and tap on \"Order\" for view details. "
        "Click button \"I've arrived\"",
    203 : "I've arrived",
    204 : "Notification send...",
    205 : "Chat",
    206 : "Wallet",
    207 : "Top up and enjoy these benefits",
    208 : "Easy payment",
    209 : "Order product with 1 click",
    210 : "Cashless delivery",
    211 : "Avoid the cash hassle",
    212 : "Instant refunds",
    213 : "When you need to cancel an order",
    214 : "Top Up",
    215 : "BALANCE",
    216 : "Top Up Now",
    217 : "Enter the amount",
    218 : "Note!\nThe delivery distance ",
    219 : "Arriving in 30-60 min",
    220 : "Change >",
    221 : "Now",
    222 : "Later",
    223 : "Confirm",
    224 : "Arriving at ",
    225 : "Enter Vehicle Information",
    226 : "Help us locate your vehicle when you arrive.",
    227 : "Select Vehicle Type:",
    228 : "Select Vehicle Color",
    229 : "SUV",
    230 : "Sedan",
    231 : "Coupe",
    232 : "Track",
    233 : "Bike",
    234 : "Other",
    235 : "Black",
    236 : "Red",
    237 : "White",
    238 : "Gray",
    239 : "Silver",
    240 : "Green",
    241 : "Blue",
    242 : "Brown",
    243 : "Gold",
    244 : "Save Vehicle Information",
    245 : "Vehicle Type:",
    246 : "Vehicle Color",
    248 : "Select Vehicle Type",
    249 : "PayPal",
    250 : "PayPal Payment",
    251 : "PayStack",
    252 : "It's ordered!",
    253 : "Order No. #",
    254 : "You've successfully placed the order",
    255 : "You can check status of your order by using our delivery status feature. You will receive an order confirmation message.",
    256 : "Show All my orders",
    257 : "Back to shop",
    258 : "Coupon",
    260 : "have maximum delivery distance is ",
    261 : "is very long.",
    262 : "Product",
    263 : "does not participate in the promotion",
    264 : "The minimum purchase amount must be",
    265 : "Yandex.Kassa",
    266 : "Instamojo",
    268 : "Categories",
    269 : "Sign In with Google",
    270 : "Sign In with Facebook",
    271 : " or ",
    272 : "This email is busy",
    273 : "Log In with Google",
    274 : "Log In with Facebook",
    275 : "Show Delivery Area",
    276 : "This filter will work throughout the application.",
    277 : "Select Address on Map",
    278 : "Add Address",
    279 : "Latitude",
    280 : "Longitude",
    281 : "Home",
    282 : "Work",
    283 : "Other",
    284 : "Default",
    285 : "Addresses not found",
    286 : "Enter address",
    287 : "default",
    288 : "On phone number",
    289 : "send SMS with code. Enter code",
    290 : "Failed to Verify Phone Number",
    291 : "Failed to sign in",
    292 : "Enter Vehicle Number",
    293 : "Vehicle Number",
    294 : "Minimum order amount",
    295 : "Variants",
    296 : "See Also",
    297 : "Reviews",
    298 : "Log In with Apple",
    299 : "Sign In with Apple",
    300 : "per",
    301 : "Delivery fee",
    302 : "From",
    303 : "To",
    304 : "Distance",
    305 : "Show order on map",
    306 : "Do you really want to exit?",
    307 : "Exit",
    308 : "Arriving date: ",
    309 : "Select maximum distance: ",
    310 : "Guest",
    311 : "Search for products",
    312 : "Filter",
    313 : "Quantity",
    314 : "Share This App",
    315 : "Select your city",
    316 : "Save",
    317 : "Please select your city",
    318 : "Select city",
    319 : "All cities",

    //
    1010 : "Restaurants",
    1082 : "You can add to cart, only products from single restaurant. Do you want to reset cart? And add new product.",
    1142 : "Enjoying Restaurant?",
    1143 : "How would you rate this Restaurant?",
    1200 : "Top Restaurants this week",
    1247 : "Pickup from restaurant",
    1259 : "The Restaurant: ",
    1267 : "Restaurant",

    //
    2010 : "Market",
    2082 : "You can add to cart, only products from single market. Do you want to reset cart? And add new product.",
    2142 : "Enjoying Market?",
    2143 : "How would you rate this Market?",
    2200 : "Top Market this week",
    2247 : "Pickup from Market",
    2259 : "The Market: ",
    2267 : "Market",

    //
    3010 : "Markets",
    3082 : "You can add to cart, only products from single market. Do you want to reset cart? And add new product.",
    3142 : "Enjoying Market?",
    3143 : "How would you rate this Market?",
    3200 : "Top Market this week",
    3247 : "Pickup from Market",
    3259 : "The Market: ",
    3267 : "Market",
  };

  //
  //
  //
  setLang(int id){
    pref.set(Pref.language, "$id");
    if (id == english) {
      defaultLang = langEng;
      init = true;
    }
    if (id == german) {
      defaultLang = langDeu;
      init = true;
    }
    if (id == espanol) {
      defaultLang = langEsp;
      init = true;
    }
    if (id == french) {
      defaultLang = langFrench;
      init = true;
    }
    if (id == korean) {
      defaultLang = langKorean;
      init = true;
    }
    if (id == arabic) {
      defaultLang = langArabic;
      init = true;
    }
    if (id == portugal){
      defaultLang = langPort;
      init = true;
    }
    if (id == rus){
      defaultLang = langRus;
      init = true;
    }
    for (var lang in langData) {
      lang.current = false;
      if (lang.id == id) {
        lang.current = true;
        direction = lang.direction;
      }
    }
  }

  Map<int, String> defaultLang;
  var init = false;

  String get(int id){
    if (!init) return "";
    if (theme.appTypePre == "restaurants"){
      switch (id){
        case 10: id = 1010; break;
        case 82: id = 1082; break;
        case 142: id = 1142; break;
        case 143: id = 1143; break;
        case 200: id = 1200; break;
        case 247: id = 1247; break;
        case 259: id = 1259; break;
        case 267: id = 1267; break;
      }
    }
    if (theme.appTypePre == "market"){
      switch (id){
        case 10: id = 2010; break;
        case 82: id = 2082; break;
        case 142: id = 2142; break;
        case 143: id = 2143; break;
        case 200: id = 2200; break;
        case 247: id = 2247; break;
        case 259: id = 2259; break;
        case 267: id = 2267; break;
      }
    }
    if (theme.appTypePre == "markets"){
      switch (id){
        case 10: id = 3010; break;
        case 82: id = 3082; break;
        case 142: id = 3142; break;
        case 143: id = 3143; break;
        case 200: id = 3200; break;
        case 247: id = 3247; break;
        case 259: id = 3259; break;
        case 267: id = 3267; break;
      }
    }
    var str = defaultLang[id];
    if (str == null)
      str = "";

    return str;
  }
}

