import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huggingface_dart/huggingface_dart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class sentimentanalysis extends StatefulWidget {
  static const String route = '/home';
  static const String path = '/home';
  static const String name = 'Home Screen';
  @override
  State<sentimentanalysis> createState() => _sentimentanalysisState();
}

class _sentimentanalysisState extends State<sentimentanalysis> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _sentimentController = TextEditingController();
  String _outputText = '';
  late HfInference _hfInference;
  late List<SentimentData> data;
  late TooltipBehavior _tooltip;
  @override
  void initState() {
    data = [];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
    super.initState();
    _hfInference = HfInference('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');
  }

  List<SentimentData> sentimentDataList = [];

  final _formKey = GlobalKey<FormState>();

  Future<void> sentimentAnalysis() async {
    final inputText = _inputController.text;

    if (inputText.isNotEmpty) {
      try {
        final result = await _hfInference.textClassification(
            inputs: inputText, model: 'ElKulako/cryptobert');
        setState(() {
          if (result.isNotEmpty && result[0] is List) {
            sentimentDataList.clear();
            for (var item in result[0]) {
              if (item is Map &&
                  item['label'] is String &&
                  item['score'] is double) {
                sentimentDataList
                    .add(SentimentData(item['label'], item['score']));
              } else {
                print('Unexpected item format: $item');
              }
            }
            SentimentData highestSentiment = sentimentDataList.reduce(
                (current, next) => current.score > next.score ? current : next);
            _sentimentController.text = highestSentiment.sentiment;
            print(_sentimentController.text);
            // _outputText = sentimentDataList
            //     .map((data) => '${data.sentiment}: ${data.score.toString()}')
            //     .join(', ');

            // SentimentAnalysis sentiment = SentimentAnalysis(
            //   text: _inputController.text,
            //   sentiment: _sentimentController.text,
            // );
            // print("user: ${widget.username}");
            // print(_sentimentController.text);
            // _postsentiment(sentiment); // Calling async function
          } else {
            _outputText = 'No data available or unexpected response format';
            print('Unexpected result format: $result');
          }
        });
      } catch (error) {
        print('Sentiment Analysis error: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    return Material(
      color: Colors.white,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 60, top: 50),
              child: Container(
                  child: Row(
                children: [
                  Image.asset(
                    'assets/icons/Bitcoin-Logo.png',
                    width: 70,
                  ),
                  Text('CryptoBERT',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0C356A),
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                      )),
                ],
              )),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 45),
              child: Text(
                'Enter  your own text',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                // height: 183,
                // width: 707,
                height: screenheight * 0.3,
                width: screenwidth * 0.8,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black
                        .withOpacity(0.3), // Black color with 30% visibility
                    width: 0, // Border stroke width
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                      16.0), // Optional: add padding inside the container
                  child: TextFormField(
                    controller: _inputController,
                    decoration: InputDecoration(
                      hintText:
                          'This is the best cryptocurrency-text sentiment analyzer ever!',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF424242),
                      ),
                      border: InputBorder.none, // No border for the text field
                    ),
                    maxLines: null, // Allow multiple lines of input
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(left: 45),
              child: SizedBox(
                width: 117,
                height: 34,
                child: Material(
                  elevation: 10,
                  shadowColor: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFF176BCE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: sentimentAnalysis,
                    child: Text("Analyze",
                        style: GoogleFonts.inter(
                          color: const Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        )),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(left: 45),
              child: Text(
                'Results',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Container(
                  height: screenheight * 0.17,
                  width: screenwidth * 0.8,
                  child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                          majorGridLines: MajorGridLines(width: 0)),
                      primaryYAxis: NumericAxis(
                          minimum: 0,
                          maximum: 1,
                          interval: 0.1,
                          majorGridLines: MajorGridLines(width: 0)),
                      tooltipBehavior: _tooltip,
                      series: <CartesianSeries<SentimentData, String>>[
                        BarSeries<SentimentData, String>(
                          dataSource: sentimentDataList,
                          xValueMapper: (SentimentData data, _) =>
                              data.sentiment,
                          yValueMapper: (SentimentData data, _) => data.score,
                          name: 'cryptoBERT',
                          pointColorMapper: (SentimentData data, _) =>
                              getColor(data.sentiment),
                        )
                      ])),
            )
          ]),
    );
  }
}

class SentimentData {
  SentimentData(this.sentiment, this.score);

  final String sentiment;
  final double score;
}

// Function to get color based on sentiment
Color getColor(String sentiment) {
  switch (sentiment) {
    case 'Bullish':
      return Colors.green;
    case 'Neutral':
      return Colors.yellow;
    case 'Bearish':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
