import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/models/user_model.dart';
import 'package:flutter/material.dart';

class SearchCustomAppBar extends StatefulWidget {
  final UserModel user;
  const SearchCustomAppBar({super.key, required this.user});

  @override
  State<SearchCustomAppBar> createState() => _SearchCustomAppBarState();
}

class _SearchCustomAppBarState extends State<SearchCustomAppBar> {
  final searchCtrl = TextEditingController();
  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: Dimensions.width(context) * 0.17,
      leading: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 18),
        ),
      ),
      flexibleSpace: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width(context) * 0.01,
          vertical: Dimensions.height(context) * 0.01,
        ),
        decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: Dimensions.height(context) * 0.055,
                    padding: EdgeInsets.only(
                      left: Dimensions.width(context) * 0.16,
                    ),
                    alignment: Alignment.topLeft,
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      elevation: 1,
                      child: TextFormField(
                        controller: searchCtrl,
                        onFieldSubmitted: (value) {},
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
                IconButton(onPressed: () {}, icon: Icon(Icons.mic)),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Dimensions.width(context) * 0.02,
                top: Dimensions.height(context) * 0.01,
              ),
              child: Row(
                children: [
                  Icon(Icons.location_pin, size: 13),
                  SizedBox(width: Dimensions.width(context) * 0.01),
                  Expanded(
                    child: Text(
                      "Deliver to ${widget.user.name}: ${widget.user.address}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width(context) * 0.01,
                    ),
                    child: Icon(Icons.arrow_drop_down, size: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      title: null,
    );
  }
}
