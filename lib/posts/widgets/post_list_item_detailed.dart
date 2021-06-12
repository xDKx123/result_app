import 'package:flutter/material.dart';
import 'package:result_app/posts/posts.dart';
import 'package:intl/intl.dart';
import 'package:utility_repository/utility_repository.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

///Displays all contract data
///#First we show vehicle data
///##Vehicle details
///##Service information
///##Damages
///##Accessories
///##Exstras
///
///#Delivired by
///#Received by
class PostListItemDetailed extends StatelessWidget {
  static Route route(Post post) {
    return MaterialPageRoute<void>(builder: (_) => PostListItemDetailed(post: post));
  }

  const PostListItemDetailed({Key? key, required this.post}) : super(key: key);

  final Post post;

  _buildMobile(Post post) {
    return ListView(
      padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
      children: [
        VehicleDetails(
          vehicleDetails: post.content['Vehicle details'] as Map<String, dynamic>,
          serviceDetails: post.content['Service information'] as Map<String, dynamic>,
          damagesDetails: post.content['Damages']['Damages'] as List<dynamic>,
          accessoriesDetails: post.content['Accessories']['Accessories'] as List<dynamic>,
          extrasDetails: post.content['Extras'] as Map<String, dynamic>,
        ),
        DeliveredBy(deliveredDetails: post.content['Delivered by'][0]),
        ReceivedBy(receivedDetails: post.content['Received by'][0]),
      ],
    );
  }

  _buildWeb(BuildContext context, Post post) {
    return SafeArea(
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 6,
          ),

          Expanded(child: ListView(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            children: [
              VehicleDetails(
                vehicleDetails: post.content['Vehicle details'] as Map<String, dynamic>,
                serviceDetails: post.content['Service information'] as Map<String, dynamic>,
                damagesDetails: post.content['Damages']['Damages'] as List<dynamic>,
                accessoriesDetails: post.content['Accessories']['Accessories'] as List<dynamic>,
                extrasDetails: post.content['Extras'] as Map<String, dynamic>,
              ),
              DeliveredBy(deliveredDetails: post.content['Delivered by'][0]),
              ReceivedBy(receivedDetails: post.content['Received by'][0]),
            ],
          ),),

          Container(
              width: MediaQuery.of(context).size.width / 6,
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Utility.getDate(post.content['date'][0]['dates']['date'].toString())),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          switch (ScreenWidth.DetermineScreen(constraints.maxWidth)) {
            case ScreenWidthStatus.ExtraSmall:
              return _buildMobile(post);

            case ScreenWidthStatus.Small:
              return _buildMobile(post);

            case ScreenWidthStatus.Medium:
              return _buildWeb(context, post);

            case ScreenWidthStatus.Large:
              return _buildWeb(context, post);
          }
        }
      ),
    );
  }
}

///Shows all information about vehicle section
class VehicleDetails extends StatelessWidget{
  const VehicleDetails({
    Key? key,
    required this.vehicleDetails,
    required this.serviceDetails,
    required this.damagesDetails,
    required this.accessoriesDetails,
    required this.extrasDetails}) : super(key: key);

  final Map<String, dynamic> vehicleDetails;
  final Map<String, dynamic> serviceDetails;
  final List<dynamic> damagesDetails;
  final List<dynamic> accessoriesDetails;
  final Map<String, dynamic> extrasDetails;


  Widget _element(Icon leadingIcon, String Title, List<Widget> subElements) {
    return ExpansionTile(
      leading: leadingIcon,
      title: Text(Title),
      children: subElements,
    );
  }

  Widget _information(String title, dynamic info) {
    return ListTile(
      leading: Text(title + ':'),
      trailing: Text(info.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
          children: [
            Text(vehicleDetails["Make"].toString(), style: TextStyle(fontSize: 35)),
            Container(height: 5,),
            _element(
                Icon(Icons.info, color: Colors.black),
                "Vehicle information: ",
                [
                  _information('Model', vehicleDetails["Model"]),
                  _information('Year', vehicleDetails["Year"]),
                  _information('Plate number', vehicleDetails["Plate number"]),
                  _information('Chassis number', vehicleDetails["Chassis number"]),
                  _information('Engine', vehicleDetails["ccm"].toString() + "ccm\t\t" + vehicleDetails["kW"].toString() + "kw"),
                  _information('Fuel', vehicleDetails["Fuel"]),
                  _information('Color external', vehicleDetails["Color external"]),
                  _information('Color internal', vehicleDetails["Color internal"]),
                  _information('Number of seats', vehicleDetails["Number of seats"]),
                ]
            ),
            _element(
                Icon(Icons.miscellaneous_services, color: Colors.blue,),
                "Service: ",
                [
                  _information('External cleanliness', serviceDetails["External cleanliness"]),
                  _information('Fuel level', serviceDetails["Fuel level"]),
                  _information('Internal cleanliness', serviceDetails["Internal cleanliness"]),
                  _information('Mileage', serviceDetails["Mileage"].toString() + " km"),
                ]
            ),
            _element(
                Icon(FontAwesomeIcons.carCrash, color: Colors.red,),
                "Damages: ",
                []
            ),
            _element(
                Icon(Icons.star, color: Colors.amberAccent,),
                "Accessories: ",
                []
            ),
            _element(
                Icon(Icons.add, color: Colors.green),
                "Extras: ",
                [
                  _information('Additional comments', extrasDetails["Additional comments"]),
                  _information('Aftermarket extras', extrasDetails["Aftermarket extras"]),
                  _information('Extras', extrasDetails["Extras"]),
                ]
            ),
          ],
        ),
    );
  }
}

///Shows all information about delivered section
class DeliveredBy extends StatelessWidget {
  const DeliveredBy({Key? key, required this.deliveredDetails}) : super(key: key);

  final Map<String, dynamic> deliveredDetails;

  Widget _information(String title, dynamic info) {
    return ListTile(
      leading: Text(title),
      trailing: Text(info.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.account_box_outlined),
      title: Text('Delivered by:'),
      children: [
        _information('Name', deliveredDetails["Name"]),
        _information('Deliverer e-mail', deliveredDetails["Deliverer e-mail"]),
        _information('Company name', deliveredDetails["Company name"]),
        _information('Fleet manager e-mail', deliveredDetails["Fleet manager e-mail"]),
        _information('Company name', deliveredDetails["Company name"]),
        _information('Phone', deliveredDetails["Phone"]),
        _information('Street, Nr.', deliveredDetails["Street, Nr."]),
        _information('Town', deliveredDetails["Town"]),
      ],
    );
  }
}

///Shows all information about receiver section
class ReceivedBy extends StatelessWidget {
  const ReceivedBy({Key? key, required this.receivedDetails}) : super(key: key);

  final Map<String, dynamic> receivedDetails;

  Widget _information(String title, dynamic info) {
    return ListTile(
      leading: Text(title),
      trailing: Text(info.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.account_box),
      title: Text('Received by:'),
      children: [
        _information('Name', receivedDetails["Name"]),
        _information('E-mail address', receivedDetails["E-mail address "]),
        _information('Company name', receivedDetails["Company name"]),
        _information('Phone number', receivedDetails["Phone number "]),
        _information('Street, Nr.', receivedDetails["Street, Nr."]),
        _information('Town', receivedDetails["Town"]),
      ],
    );
  }
}