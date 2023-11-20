import 'package:flutter/material.dart';

class PopularRecipeList extends StatefulWidget {
  const PopularRecipeList({Key? key}) : super(key: key);

  @override
  State<PopularRecipeList> createState() => _PopularRecipeListState();
}

class _PopularRecipeListState extends State<PopularRecipeList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 1,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            height: 380,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              textAlign: TextAlign.justify,
                              'Have you ever wondered what impact your daily household products can have on the environment? Seemingly unharmful products may contain ingredients that might be toxic to the environment. As awareness about this issue grows, individuals may seek to make informed choices but lack the time or reliable sources to conduct thorough analyses of the impact of their consumption patterns on the environment. Consequently, there exists a pressing challenge to facilitate timely, credible, and convenient access to information that empowers individuals to make informed and environmentally responsible decisions.\n\nEcoGo is an app that provides information on the environmental impact of the ingredients used in products and how they affect the environment.',

                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 45, 63, 71),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
