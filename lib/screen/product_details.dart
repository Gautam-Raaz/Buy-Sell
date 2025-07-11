import 'package:buy_and_sell/controller/user_controller.dart';
import 'package:buy_and_sell/models/product.dart';
import 'package:buy_and_sell/models/user.dart';
import 'package:buy_and_sell/screen/profile_screen.dart';
import 'package:buy_and_sell/widget/banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


class ProductDetails extends StatefulWidget {
  final Product data;
  final bool isAllowed;

  const ProductDetails({super.key, required this.data,required this.isAllowed});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  User? userData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    userData = await UserController().getUserData(widget.data.phone);
    setState(() {
      
    });
  }

  Future<void> _launchWhatsApp() async {
    final String message =
        "Hello! I'm interested in your product ${widget.data.name}.Is it available"; // Custom message
        print(widget.data.phone);

    final String url =
        "https://wa.me/91${widget.data.phone.replaceAll('+', '')}?text=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        title: Text("Product Details", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// banner
              Container(
                height: 270,
                child: ImageBanner(imageUrls: widget.data.photos),
              ),

              Divider(thickness: 2),

               SizedBox(height: 20,),
           
                    /// profile pic
                  if(userData != null)  GestureDetector(
                    onTap: () {
                      if(widget.isAllowed) {
                        Navigator.push(
                      context,MaterialPageRoute(builder: (context) => ProfileScreen(phone: widget.data.phone,)),);
                      }
                    },
                    child: CircleAvatar(
                       radius: 50,
                       backgroundImage: NetworkImage(userData!.profilePic),
                       backgroundColor: Colors.white,
                      ),
                  ),
          
          
                    /// name
                    SizedBox(height: 20,),
                    if(userData != null)  Text(userData!.name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),



              /// name
              SizedBox(height: 20),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Row(
                  children: [
                    Text(
                      "Product Name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Text(widget.data.name),
                  ],
                ),
              ),

              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Row(
                  children: [
                    Text(
                      "Original Price",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Text(widget.data.buyprice),
                  ],
                ),
              ),

              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Row(
                  children: [
                    Text(
                      "Selling Price",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Text(widget.data.sellprice),
                  ],
                ),
              ),

              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Row(
                  children: [
                    Text(
                      "Buying Date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Text(DateFormat('dd/MM/yyyy').format(widget.data.buyDate)),
                  ],
                ),
              ),

              SizedBox(height: 20),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Product Description',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Text(widget.data.description, maxLines: 8),

              SizedBox(height: 20,),

              GestureDetector(
                onTap: () => _launchWhatsApp(),
                child: Row(
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/WhatsApp.svg',
                        height: 40,
                        width: 40,
                      ),
                      onPressed: () {},
                      tooltip: 'Chat on WhatsApp',
                    ),
                    Text("Chat on WhatsApp",style: TextStyle(fontWeight: FontWeight.bold),)
                    
                  ],
                ),
              ),

              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }
}
