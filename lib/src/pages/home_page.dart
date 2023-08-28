import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:traductor/src/services/translate_service.dart';
import 'package:traductor/src/utils/ad_helper.dart';
import 'package:traductor/src/utils/list_idioma.dart';
import 'package:traductor/src/widgets/tema_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TranslateService _translateService = TranslateService();
  String _traduccion = "Traducción";
  String _auxText = "";
  final _textController = TextEditingController();
  String _idioma = "Inglés";
  String _auxIdioma = "en";

  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(
          onAdLoaded: (_) {
            setState(() {
              _isLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // ignore: avoid_print
            print('Error al poner el anuncio: ' + error.message);
            _isLoaded = false;
            ad.dispose();
          },
        ),
        request: const AdRequest());

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          elevation: 15.h,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.h),
                  bottomRight: Radius.circular(60.h))),
          centerTitle: true,
          title: Column(
            children: [
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/img/traductor.png",
                    width: 30.h,
                  ),
                  SizedBox(width: 12.h),
                  Text(
                    "Traductor Básico",
                    style: TextStyle(fontSize: 25.h, fontFamily: 'Barlow'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TemaWidget(),
                  SizedBox(
                    width: 10.h,
                    height: 3.h,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Card(
        elevation: 10.h,
        margin: EdgeInsets.all(12.h),
        child: ListView(
          padding: EdgeInsets.all(12.h),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Auto Detección",
                  style: TextStyle(
                      fontFamily: 'Barlow',
                      fontSize: 18.h,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  tooltip: 'Vaciar Texto',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    _traduccion = "Traducción";
                    _textController.clear();
                    _auxText = "";
                    setState(() {});
                  },
                )
              ],
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _textController,
              maxLines: 2,
              maxLength: 300,
              keyboardType: TextInputType.text,
              onChanged: (text) async {
                for (var i = 0; i < idiomas.length; i++) {
                  if (_idioma == idiomas[i].idioma) {
                    _auxIdioma = idiomas[i].code;
                  }
                }
                _traduccion =
                    await _translateService.translate(text, _auxIdioma);
                _auxText = text;
                setState(() {});
              },
              style: TextStyle(
                  fontSize: 28.h,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Barlow'),
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  errorText: _validateText(_auxText),
                  hintText: 'Ingrese el Texto...'),
            ),
            SizedBox(height: 10.h),
            Container(
              margin: EdgeInsets.fromLTRB(45.h, 0, 45.h, 0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 1.h),
                  borderRadius: BorderRadius.circular(18.h)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.translate_outlined),
                  SizedBox(width: 3.h),
                  DropdownButton<String>(
                      alignment: AlignmentDirectional.center,
                      borderRadius: BorderRadius.circular(18.h),
                      menuMaxHeight: 250.h,
                      onChanged: (String? newValue) {
                        _idioma = newValue!;
                        setState(() {});
                      },
                      value: _idioma,
                      elevation: 18,
                      style: TextStyle(
                        fontFamily: 'Barlow',
                        fontSize: 20.h,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                      underline: Container(height: 3.h),
                      items: idiomas
                          .map((e) => e.idioma)
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList()),
                ],
              ),
            ),
            Divider(height: 18.h),
            Container(
              margin: EdgeInsets.all(8.h),
              child: Text(
                _traduccion,
                style: TextStyle(
                    fontFamily: 'Barlow',
                    fontSize: 32.h,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold),
              ),
            ),
            chechForAd(),
          ],
        ),
      ),
    );
  }

  Widget chechForAd() {
    if (_isLoaded == true) {
      return Container(
        child: AdWidget(
          ad: _bannerAd!,
        ),
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        alignment: Alignment.center,
      );
    } else {
      return Center(
          child: Padding(
        padding: EdgeInsets.all(12.h),
        child: Text('Anuncio', style: TextStyle(fontSize: 5.h)),
      ));
    }
  }

  _validateText(String value) {
    if (value.length == 300) {
      return "Máximo de caracteres alcanzado";
    }
    return null; //Cuando se retorna nulo el campo de texto está validado
  }
}
