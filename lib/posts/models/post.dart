import 'package:equatable/equatable.dart';

///Saves contract converted from json object
class Post extends Equatable {
  const Post({required this.content});

  final Map<String, dynamic> content;

  @override
  List<Object> get props => [content];

}