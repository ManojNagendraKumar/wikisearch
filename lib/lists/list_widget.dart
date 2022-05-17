import 'package:assessment_app/screens/details_screen.dart';
import 'package:flutter/material.dart';

class ListWidget extends StatefulWidget {
  var pageId;
  String? title;
  String? description;
  String? image;
  String? alias;
  String? pageImage;
  String? label;

  ListWidget(
      {this.description,
      this.image,
      this.title,
      this.alias,
      this.label,
      this.pageId,
      this.pageImage});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return DetailsScreen(
            alias: widget.alias,
            label: widget.label,
            pageImage: widget.pageImage,
            pageid: widget.pageId,
            title: widget.title,
            description: widget.description,
            image: widget.image,
          );
        }));
      },
      child: ListTile(
        leading: widget.image == null
            ? Image.asset(
                'image/new_image.jpeg',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(widget.image!)),
        title: Text(widget.title!),
        subtitle: widget.description == null ||
                widget.description!.isEmpty ||
                widget.description == 'Wikimedia disambiguation page'
            ? const Text('')
            : Container(
                padding: const EdgeInsets.all(3),
                child: Text(
                  widget.description!,
                  overflow: TextOverflow.ellipsis,
                )),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: _size.width * 0.02),
          child: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
          ),
        ),
      ),
    );
  }
}
