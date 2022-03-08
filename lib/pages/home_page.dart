import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedDate = DateTime.now();
  var selected = false;
  var f = DateFormat("dd/MM/yyyy EEEE");
  var numList = [1, 4, 0, 3, 6, 2, 5];

  var modVal = 0;
  var houseName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        title: const Text('မဟာဘုတ်'),
      ),
      body: _homeDesign(),
    );
  }

  String _houseResult(year, day) {
    var houses = ["ဘင်္ဂ", "အထွန်း", "ရာဇ", "အဓိပတိ", "မရဏ", "သိုက်", "ပုတိ"];
    return houses[(year - day - 1) % 7];
  }

  var isChecked = false;
  //1,4,0,3,6,2,5
  Widget _homeDesign() => ListView(
        children: <Widget>[
          _firstCard(),
          selectedDate.month == 4
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      activeColor: Colors.orange,
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                          var mmYear = 0;
                          if (isChecked) {
                            mmYear = selectedDate.year - 639;
                          } else {
                            mmYear = selectedDate.year - 638;
                          }
                          _changeState(selectedDate, mmYear);
                        });
                      },
                    ),
                    const Text(
                      'သင်သည် နှစ်သစ်ကူးမှာမွေးဖွားပါသလား',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )
              : Container(),
          _secondCard(),
          selected == false ? Container() : _thirdResLayout(),
          selected ? _resultNumberLayout() : Container()
        ],
      );

  TextStyle _selectedColor(chosenVal, val) =>
      TextStyle(color: chosenVal == val ? Colors.orange : Colors.white);

  Padding _labelText(val) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(val,
            textAlign: TextAlign.center, style: _selectedColor(houseName, val)),
      );
  Widget _numberText(val) {
    var day = (selectedDate.weekday + 1) % 7;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(val,
          textAlign: TextAlign.center,
          style: _selectedColor(day.toString(), val)),
    );
  }

  void _changeState(DateTime picked, var myanmarYear) {
    setState(() {
      selectedDate = picked;
      modVal = myanmarYear % 7;
     
      _updateList(modVal);
      houseName = _houseResult(myanmarYear, picked.weekday);
      selected = true;
    });
  }

  void _updateList(int mod) {
    var temp = numList.sublist(numList.indexOf(mod), numList.length);
    temp.addAll(numList.sublist(0, numList.indexOf(mod)));
    setState(() {
      numList = temp;
    });
  }

 

  Widget _firstCard() => Container(
        margin: const EdgeInsets.all(10.0),
        height: 130,
        child: Card(
          elevation: 8.0,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'အဖွားဇာတာတွက်ရန် သင်၏မွေးနေ့ကိုရွေးခြယ်ပေးပါ',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.orange),
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(1800),
                            lastDate: DateTime(2025),
                            helpText:
                                'Select Your Birthday', // Can be used as title
                            cancelText: 'Not now');
                        if (picked != null) {
                          var myanmarYear = picked.year - 638;
                          if (picked.month < 4) {
                            myanmarYear = picked.year - 637;
                          }

                          setState(() {
                            selectedDate = picked;
                            modVal = myanmarYear % 7;
                            houseName =
                                _houseResult(myanmarYear, picked.weekday);
                            selected = true;
                          });
                        }
                      },
                      child: selected
                          ? Text(
                              f.format(selectedDate),
                              style: const TextStyle(color: Colors.white),
                            )
                          : const Text(
                              'မွေးနေ့ရွေးချယ်ရန် နှိပ်ပါ ',
                              style: TextStyle(color: Colors.white),
                            )),
                ],
              ),
            ),
          ),
        ),
      );
  Widget _secondCard() => Container(
        margin: const EdgeInsets.all(10),
        height: 250,
        child: Card(elevation: 8.0, child: Center(child: _mahaboteLayout())),
      );

  Widget _thirdResLayout() => Container(
        margin: const EdgeInsets.all(10),
        child: Card(
            elevation: 8.0,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('သင်သည်'),
                  Text(
                    ' $houseName ',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Colors.orange),
                  ),
                  const Text('ဖွားဖြစ်ပါသည်။')
                ],
              ),
            )),
      );

  Widget _resultNumberLayout() => Container(
        margin: const EdgeInsets.all(10),
        height: 230,
        child:
            Card(elevation: 8.0, child: Center(child: _mahaboteNumberLayout())),
      );

  Widget _mahaboteLayout() => Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Table(
            border: const TableBorder(
              verticalInside: BorderSide(
                color: Colors.white,
                width: 1,
              ),
              horizontalInside: BorderSide(
                color: Colors.white,
                width: 1,
              ),
            ),
            children: [
              TableRow(
                children: [
                  const Text(""),
                  _labelText("အဓိပတိ"),
                  const Text(""),
                ],
              ),
              TableRow(
                children: [
                  _labelText("အထွန်း"),
                  _labelText("သိုက်"),
                  _labelText("ရာဇ"),
                ],
              ),
              TableRow(
                children: [
                  _labelText("မရဏ"),
                  _labelText("ဘင်္ဂ"),
                  _labelText("ပုတိ"),
                ],
              ),
            ],
          ),
        ),
      );

  // Widget _numberLayout() => Padding(
  //       padding: const EdgeInsets.all(10),
  //       child: Column(
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Text(""),
  //               _numText("${numList[6]}"),
  //               Text(""),
  //             ],
  //           ),
  //           //2nd row
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               _numText("${numList[2]}"),
  //               _numText("${numList[3]}"),
  //               _numText("${numList[4]}"),
  //             ],
  //           ),
  //           // 3rd row
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               _numText("${numList[1]}"),
  //               _numText("${numList[0]}"),
  //               _numText("${numList[5]}"),
  //             ],
  //           ),
  //         ],
  //       ),
  //     );

  Widget _mahaboteNumberLayout() => Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('အကြွင်း'),
                  Text(
                    ' $modVal',
                    style:
                        const TextStyle(color: Colors.orange, fontSize: 18.0),
                  ),
                  const Text(' မဟာဘုတ်ဂဏန်းကွက်')
                ],
              ),
              Table(
                border: const TableBorder(
                  verticalInside: BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                  horizontalInside: BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                children: [
                  TableRow(
                    children: [
                      const Text(""),
                      _numberText("${numList[6]}"),
                      const Text(""),
                    ],
                  ),
                  TableRow(
                    children: [
                      _numberText("${numList[2]}"),
                      _numberText("${numList[3]}"),
                      _numberText("${numList[4]}"),
                    ],
                  ),
                  TableRow(
                    children: [
                      _numberText("${numList[1]}"),
                      _numberText("${numList[0]}"),
                      _numberText("${numList[5]}"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
