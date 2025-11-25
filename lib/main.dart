import 'package:flutter/material.dart';

void main() {
  runApp(const CoffeeMenuApp());
}

class CoffeeMenuApp extends StatelessWidget {
  const CoffeeMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Shop Menu',
      home: Scaffold(
        appBar: AppBar(title: const Text("Coffee Shop",style: TextStyle(color: Colors.white),),
          centerTitle: true,
          toolbarHeight: 299,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/shop.jpg'),fit: BoxFit.cover)
            ),
          ),
        ),
        body: const CoffeeMenuPage(),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }
}

class CoffeeMenuPage extends StatefulWidget {
  const CoffeeMenuPage({super.key});

  @override
  State<CoffeeMenuPage> createState() => _CoffeeMenuPageState();
}

class _CoffeeMenuPageState extends State<CoffeeMenuPage>
    with TickerProviderStateMixin {
  int? expandedIndex;

  final List<String> categories = ["Cold Drinks", "Shisha", "Hot Drinks"];

  // Colors for the 9 items grid (different per category)
  final List<Color> categoryColors = [
    Colors.yellow,
    Colors.green,
    Colors.blue
  ];

  // Images for the buttons
  final List<String> buttonImages = [
    'assets/images/cold.jpg',
    'assets/images/shisha.webp',
    'assets/images/hot.webp',
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Buttons row with images
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(categories.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (expandedIndex == index) {
                      expandedIndex = null;
                    } else {
                      expandedIndex = index;
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  height: 200,
                  width: screenWidth * 0.28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.redAccent, // fallback if image missing
                    image: DecorationImage(
                      image: AssetImage(buttonImages[index]),
                      fit: BoxFit.fill,
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      categories[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }),
          ),

          // Grid of items below the row
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return SizeTransition(
                sizeFactor: animation,
                axis: Axis.vertical,
                child: child,
              );
            },
            child: expandedIndex != null
                ? _buildGrid(expandedIndex!)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(int index) {
    return Container(
      key: ValueKey(index),
      padding: const EdgeInsets.all(10),
      child: GridView.count(
        crossAxisCount: 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1,
        children: List.generate(9, (i) {
          return Container(
            color: categoryColors[index].withOpacity(0.8),
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    buttonImages[index], // same image repeated for now
                    fit: BoxFit.cover,
                    width: 90,
                    height: 60,
                  ),
                ),
                Text("data")
              ],
            ),
          );
        }),
      ),
    );
  }
}
