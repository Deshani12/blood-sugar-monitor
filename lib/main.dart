import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

// Blood sugar category enum
enum BloodSugarCategory {
  normal,
  prediabetes,
  diabetes,
  high,
  invalid,
}

// Controller class using GetX
class BloodSugarController extends GetxController {
  // Input fields (observables)
  final beforeReadingRx = TextEditingController().obs;
  final afterReadingRx = TextEditingController().obs;

  // Category (observable)
  final categoryRx = BloodSugarCategory.invalid.obs;

  // Validate user input and calculate category
  void validateReadings() {
    // Extract values from observables
    final before = double.tryParse(beforeReadingRx.value.text);
    final after = double.tryParse(afterReadingRx.value.text);

    // Check for valid input
    if (before == null || after == null) {
      categoryRx.value = BloodSugarCategory.invalid;
      Get.snackbar("Error", "Please enter valid numbers for both readings.");
      return;
    }

    // Implement detailed blood sugar category mapping logic based on the provided criteria
    final calculatedCategory = _calculateCategory(before, after);

    // Update category observable
    categoryRx.value = calculatedCategory;

    // Navigate to information screen
    Get.to(InformationScreen());
  }

  // Helper function to calculate category based on values
  BloodSugarCategory _calculateCategory(double before, double after) {
    // For example:
    if (before < 100 && after < 140) {
      return BloodSugarCategory.normal;
    } else if (before < 126 || after < 200) {
      return BloodSugarCategory.diabetes;
    } else {
      return BloodSugarCategory.high;
    }
  }
}

// Input screen class
class InputScreen extends StatelessWidget {
  // Get instance of controller
  final BloodSugarController _controller = Get.put(BloodSugarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("###60e6d6"),
      appBar: AppBar(title: Text('Blood Sugar Monitor')),
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          children: [
            TextField(
              controller: _controller.beforeReadingRx.value,
              decoration: InputDecoration(labelText: 'Before Meal Reading (mg/dL)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 80.0),
            TextField(
              controller: _controller.afterReadingRx.value,
              decoration: InputDecoration(labelText: 'After Meal Reading (mg/dL)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 80.0),
            ElevatedButton(
              onPressed: _controller.validateReadings,
              child: Text('Calculate'),
            ),
          ],
        ),
      ),
    );
  }
}

// Information screen class
class InformationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final category = Get.find<BloodSugarController>().categoryRx.value;

    // Display appropriate information based on category
    return Scaffold(
      backgroundColor: HexColor('#02b09c'),
      appBar: AppBar(title: Text('Blood Sugar Information')),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 300.0),
            Text(
              'The category is: ${category.toString().split('.').last}',
              style: TextStyle(fontSize: 25.0),
            ),
            Container(
              padding: EdgeInsets.all(25.0),
              child: Text(
                'Protect Your Health!',
                style: TextStyle(fontSize: 30.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Main function
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: InputScreen(),
    );
  }  }