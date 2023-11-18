import 'package:flutter/material.dart';

class WritePage extends StatefulWidget {
  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  List<int> years = List.generate(10, (index) => DateTime.now().year + index);
  List<int> months = List.generate(12, (index) => index + 1);
  List<int> days = List.generate(31, (index) => index + 1);

  int selectedStartYear = DateTime.now().year;
  int selectedStartMonth = DateTime.now().month;
  int selectedStartDay = DateTime.now().day;

  int selectedEndYear = DateTime.now().year;
  int selectedEndMonth = DateTime.now().month;
  int selectedEndDay = DateTime.now().day;

  DateTime? studyEndDate; // nullable한 DateTime 변수 studyEndDate를 선언

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("그룹 만들기", style: TextStyle(fontSize: 23.0, color: Color(
            0xFF000000), ),
        ),
        backgroundColor: Color(0xFFF6E690), // 앱바 배경색 설정
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20,),
            _buildTextFieldWithLabel('제목', '제목을 입력하세요'),
            SizedBox(height: 16),
            _buildTextFieldWithLabel('개발 언어', '사용할 언어를 입력하세요'),
            SizedBox(height: 16),
            _buildDateDropdown('공부기간', years, months, days),
            SizedBox(height: 1),
            _buildStudyEndDateDropdown( years, months, days),
            SizedBox(height: 16),
            _buildTextFieldWithLabel('내용', '내용을 입력하세요'),
            SizedBox(height: 16),
            // 완료버튼
            ElevatedButton(
              onPressed: () {
                // 완료버튼 로직 추가
              },
              child: Text('완료', style: TextStyle(color: Colors.black, fontSize: 18),),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFF1B4)), // 버튼 배경색
                minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)), // 버튼의 최소 크기 설정
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldWithLabel(String label, String hintText,
      {int? maxLines}) {
    double? contentHeight = label == '내용' ? 350.0 : null; // label이 '내용'인 경우에는 contentHeight에 350.0을 할당하고, 그렇지 않은 경우에는 null을 할당

    EdgeInsetsGeometry labelPadding;
    switch (label) { // 각 레이블 패딩 조절
      case '제목':
        labelPadding = EdgeInsets.only(left: 5, right: 5);
        break;
      case '개발 언어':
        labelPadding = EdgeInsets.only(left: 3,right: 5);
        break;
      case '내용':
        labelPadding = EdgeInsets.only(left: 5 , right: 5);
        break;
      default:
        labelPadding = EdgeInsets.zero;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity, // Row의 전체 너비를 사용하도록 설정
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: labelPadding,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: contentHeight, // contentHeight에 따라 높이가 동적으로 결정됨
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      maxLines: maxLines, // 최대 행 수 설정
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hintText,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }


  Widget _buildDateDropdown( // 시작일 드롭다운
      String label, List<int> yearList, List<int> monthList, List<int> dayList) {
    EdgeInsetsGeometry rowPadding = EdgeInsets.zero;

    if (label == '공부기간') { // 공부기간 패딩 조절
      rowPadding = EdgeInsets.only(left: 5, right: 5);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: rowPadding,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 60, // 텍스트와 드롭다운 사이 너비
              child: Text(
                '시작일: ',
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(width: 8),
            DropdownButton<int>(
              value: selectedStartYear,
              onChanged: (value) {
                setState(() {
                  selectedStartYear = value!;
                });
              },
              items: yearList.map((int year) {
                return DropdownMenuItem<int>(
                  value: year,
                  child: Container(
                    child: Text('$year년', style: TextStyle(fontSize: 15)),
                  ),
                );
              }).toList(),
            ),
            SizedBox(width: 8),
            DropdownButton<int>(
              value: selectedStartMonth,
              onChanged: (value) {
                setState(() {
                  selectedStartMonth = value!;
                });
              },
              items: monthList.map((int month) {
                return DropdownMenuItem<int>(
                  value: month,
                  child: Text('$month월', style: TextStyle(fontSize: 15)),
                );
              }).toList(),
            ),
            SizedBox(width: 8),
            DropdownButton<int>(
              value: selectedStartDay,
              onChanged: (value) {
                setState(() {
                  selectedStartDay = value!;
                });
              },
              items: dayList.map((int day) {
                return DropdownMenuItem<int>(
                  value: day,
                  child: Text('$day일', style: TextStyle(fontSize: 15)),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }




  Widget _buildStudyEndDateDropdown( // 종료일 드롭다운
      List<int> yearList, List<int> monthList, List<int> dayList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2),
        Row(
          children: [
            Container(
              width: 60, // 텍스트와 드롭다운 사이 너비
              child: Text(
                '종료일: ',
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(width: 8),
            DropdownButton<int>(
              value: selectedEndYear,
              onChanged: (value) {
                setState(() {
                  selectedEndYear = value!;
                });
              },
              items: yearList.map((int year) {
                return DropdownMenuItem<int>(
                  value: year,
                  child: Container(
                    //width: 60,
                    child: Text('$year년', style: TextStyle(fontSize: 15)),
                  ),
                );
              }).toList(),
            ),
            SizedBox(width: 8),
            DropdownButton<int>(
              value: selectedEndMonth,
              onChanged: (value) {
                setState(() {
                  selectedEndMonth = value!;
                });
              },
              items: monthList.map((int month) {
                return DropdownMenuItem<int>(
                  value: month,
                  child: Container(
                    //width: 60,
                    child: Text('$month월', style: TextStyle(fontSize: 15)),
                  ),
                );
              }).toList(),
            ),
            SizedBox(width: 8),
            DropdownButton<int>(
              value: selectedEndDay,
              onChanged: (value) {
                setState(() {
                  selectedEndDay = value!;
                });
              },
              items: dayList.map((int day) {
                return DropdownMenuItem<int>(
                  value: day,
                  child: Container(
                    //width: 60,
                    child: Text('$day일', style: TextStyle(fontSize: 15)),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }


}
