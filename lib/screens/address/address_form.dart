import 'package:rentreerapide/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:rentreerapide/models/address.dart';
import 'package:rentreerapide/helpers/sweetAlert.dart';

class AddAddressForm extends StatefulWidget {
  @override
  _AddAddressFormState createState() => _AddAddressFormState();
}

class _AddAddressFormState extends State<AddAddressForm> {
  TextEditingController line1 = TextEditingController(text: '');
  TextEditingController line2 = TextEditingController(text: '');
  TextEditingController city = TextEditingController(text: '');
  TextEditingController state = TextEditingController(text: '');
  TextEditingController phone = TextEditingController(text: '');
  var selectedRegion;
  var selectedCity;
  List<DropdownMenuItem>regions = [];
  List<DropdownMenuItem>cities  = [];
  Color inputBackground = Color(0xfff7f7f7);
  getRegionCities(String region_id)async{
    var data = await getCities(region_id);
    setState((){
      cities = [];
      data.forEach((element) {
        DropdownMenuItem i = DropdownMenuItem(
          child: Text('${element.city_name}'),
          value: '${element.id}',
        );
        cities.add(i);
      });
    });
  }

  saveAddress() async{
    showLoader(context);
    bool result = await addAddress(
      region_id: selectedRegion,
      city: selectedCity,
      line1: line1.text,
      line2: line2.text,
      phone: phone.text
    );

    hideLoader(context);
    if(result){
      Navigator.of(context).pop();
    }
  }

  _AddAddressFormState(){
    getRegions().then((data)=>setState((){
      regions = [];
      data.forEach((element) {
        DropdownMenuItem i = DropdownMenuItem(
          child: Text('${element.region_name}'),
          value: '${element.id}',
        );
        regions.add(i);
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16.0,),
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: inputBackground,),
            child: TextField(
              controller: line1,
              // style: inputStyle,
              decoration: InputDecoration(border: InputBorder.none, hintText: 'Numero de maison'),
            ),
          ),
          SizedBox(height: 3.6,),
          Container(
            padding: EdgeInsets.only(left: 16.0,),
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: inputBackground,),
            child: TextField(
              controller: line2,
              // style: inputStyle,
              decoration: InputDecoration(border: InputBorder.none, hintText: 'Quartier'),
            ),
          ),
          SizedBox(height: 3.6,),
          Container(
            padding: EdgeInsets.only(left: 16.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: inputBackground,),
            child: DropdownButtonFormField(
                value: selectedRegion,
                dropdownColor: Colors.white,
                items: regions,
                decoration: InputDecoration(border: InputBorder.none, hintText:'Region'),
                // style: inputStyle,
                onChanged: (value)async{
                  showLoader(context,title: 'Chargement des villes');
                  setState(() {
                    selectedRegion = value;
                  });
                  await getRegionCities(value);
                  hideLoader(context);
                }),
          ),
          SizedBox(height: 3.6,),
          Container(
            padding: EdgeInsets.only(left: 16.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: inputBackground,),
            child: DropdownButtonFormField(
                value: selectedCity,
                dropdownColor: Colors.white,
                decoration: InputDecoration(border: InputBorder.none, hintText: 'Ville'),
                items: cities,
                // style: inputStyle,
                onChanged: (value){
                  setState(() {
                    selectedCity = value;
                  });
                }),
          ),
          SizedBox(height: 3.6,),
          Container(
            padding: EdgeInsets.only(left: 16.0,),
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: inputBackground,),
            child: TextField(
              controller: phone,
              // style: inputStyle,
              decoration: InputDecoration(border: InputBorder.none, hintText: 'Telephone'),
            ),
          ),
        ],
      ),
    );
  }
}
