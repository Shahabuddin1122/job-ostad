import 'package:flutter/material.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BookView extends StatefulWidget {
  const BookView({super.key});

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
    // Show a dialog to input the page number
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
                  _pdfViewerController.jumpToPage(pageNumber - 1);
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
                  alignment: Alignment.center,
                  child: Text(
                    "LAL NIL DIPABALI",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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
            child: SfPdfViewer.asset(
              "assets/pdf/LAL NIL DIPABALI (jobbooksbd.blogspot.com).pdf",
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
