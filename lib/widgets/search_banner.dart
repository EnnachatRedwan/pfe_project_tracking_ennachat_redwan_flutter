import 'package:flutter/material.dart';

import '../style/style.dart';

class SearchBanner extends StatelessWidget {
  const SearchBanner({
    Key? key,
    this.search,
  }) : super(key: key);

  final Function? search;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: Colors.transparent,
        height: 60,
        child: Stack(
          children: [
            Container(
              height: 60,
              decoration: const BoxDecoration(
                color: Style.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * .65,
                    constraints: const BoxConstraints(maxWidth: 400),
                    height: 40,
                    decoration: BoxDecoration(
                      color: Style.backgroundColor,
                      border: Border.all(color: Style.secondaryColor, width: 3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        // FittedBox(
                        //   child: IconButton(
                        //     onPressed: () {},
                        //     icon: const Icon(Icons.more_vert),
                        //     color: Style.secondaryColor,
                        //   ),
                        // ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration.collapsed(
                                hintText: 'بحث'),
                            onChanged: (value) {
                              if (search != null) {
                                search!(value);
                              }
                            },
                          ),
                        ),
                        const Icon(
                          Icons.search,
                          color: Style.secondaryColor,
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
