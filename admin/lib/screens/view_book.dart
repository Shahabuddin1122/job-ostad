import 'package:flutter/material.dart';
import 'package:admin/utils/constants.dart';
import 'package:admin/utils/custom_theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BookView extends StatefulWidget {
  final String book_pdf, title;
  const BookView({required this.title, required this.book_pdf, super.key});

  @override
  State<BookView> createState() => _BookViewState();
}

class _BookViewState extends State<BookView> {
  final PdfViewerController _pdfViewerController = PdfViewerController();

  void _goToNextPage() {
    _pdfViewerController.nextPage();
  }

  void _goToPreviousPage() {
    _pdfViewerController.previousPage();
  }

  void _findPage() {
    showDialog(
      context: context,
      builder: (context) {
        int pageNumber = 1;
        return AlertDialog(
          title: Text("Go to Page"),
          content: TextField(
            decoration: InputDecoration(hintText: "Enter page number"),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              pageNumber = int.tryParse(value) ?? 1;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (pageNumber > 0) {
                  _pdfViewerController.jumpToPage(pageNumber);
                }
                Navigator.pop(context);
              },
              child: Text("Go"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Theme.of(context).defaultPadding,
      child: Column(
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(color: PRIMARY_COLOR),
            child: Row(
              children: [
                Container(
                  width: 200,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: _goToPreviousPage,
                    ),
                    IconButton(
                      icon: Icon(Icons.search, color: Colors.white),
                      onPressed: _findPage,
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward, color: Colors.white),
                      onPressed: _goToNextPage,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SfPdfViewer.network(
              widget.book_pdf,
              controller: _pdfViewerController,
              canShowPaginationDialog: true,
              canShowScrollHead: true,
              pageLayoutMode: PdfPageLayoutMode.single,
              scrollDirection: PdfScrollDirection.vertical,
            ),
          ),
        ],
      ),
    );
  }
}
