import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:flutter/material.dart';

class CustomOrderAppBar extends StatefulWidget {
  const CustomOrderAppBar({super.key});

  @override
  State<CustomOrderAppBar> createState() => _CustomOrderAppBarState();
}

class _CustomOrderAppBarState extends State<CustomOrderAppBar> {
  final searchCtrl = TextEditingController();
  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios, size: 18),
      ),
      flexibleSpace: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width(context) * 0.01,
          vertical: Dimensions.height(context) * 0.01,
        ),
        decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: Dimensions.width(context) * 0.11,
                ),
                child: Container(
                  height: Dimensions.height(context) * 0.055,
                  padding: EdgeInsets.only(
                    left: Dimensions.width(context) * 0.02,
                  ),
                  alignment: Alignment.topLeft,
                  child: Material(
                    borderRadius: BorderRadius.circular(5),
                    elevation: 1,
                    child: TextFormField(
                      controller: searchCtrl,
                      onFieldSubmitted: (value) {
                        Navigator.pushNamed(
                          context,
                          SearchScreen.routeName,
                          arguments: value,
                        );
                        searchCtrl.clear();
                      },
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: Dimensions.width(context) * 0.01,
                        ),
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.mic)),
          ],
        ),
      ),
      title: null,
    );
  }
}
