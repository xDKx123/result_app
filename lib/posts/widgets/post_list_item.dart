import 'package:flutter/material.dart';
import 'package:result_app/posts/posts.dart';
//import 'package:result_app/posts/widgets/post_list_item_detailed.dart'
import 'package:intl/intl.dart';
import 'package:utility_repository/utility_repository.dart';

///Displays important data
class PostListItem extends StatelessWidget {
  const PostListItem({Key? key, required this.post}) : super(key: key);

  final Post post;

  String _getDate(String datetime) {
    DateTime dateTime = DateTime.parse(datetime);
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }

  //TODO: change icon depending od type of retrieval
  dynamic _getIcon(String infoType) {
    switch(infoType.toLowerCase()) {
      case 'return':
        return Icons.assignment_returned_outlined;
      default:
        return Icons.assignment_turned_in;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: Icon(_getIcon(post.content['Info']['type'])),
      title: Text('${post.content['Vehicle details']['Make']}'),
      subtitle: Text('${post.content['Vehicle details']['Plate number']}'),
      trailing: Text(Utility.getDate(post.content['date'][0]['dates']['date'].toString()),
    ),
      onTap: () {
        Navigator.push(context, PostListItemDetailed.route(post));
      },
    );
  }
}