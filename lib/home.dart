import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedRadioValue = '';
  List<String> _selectedCheckboxes = [];
  TextEditingController _textFieldController = TextEditingController();
  File? _image;
  String? _selectedDropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form '),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select an option:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              RadioGroup(
                options: const ['Option 1', 'Option 2', 'Option 3'],
                onChanged: (value) {
                  setState(() {
                    _selectedRadioValue = value!;
                  });
                },
                selectedValue: _selectedRadioValue,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Select multiple options:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              CheckboxGroup(
                options: const ['Option A', 'Option B', 'Option C'],
                onChanged: (selectedOptions) {
                  setState(() {
                    _selectedCheckboxes = selectedOptions;
                  });
                },
                selectedValues: _selectedCheckboxes,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Select an option from dropdown:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              DropdownButtonFormField<String>(
                value: _selectedDropdownValue,
                onChanged: (newValue) {
                  setState(() {
                    _selectedDropdownValue = newValue;
                  });
                },
                items: ['Option X', 'Option Y', 'Option Z']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Select an option',
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Upload an image:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              ImageUploader(
                image: _image,
                onImageSelected: (image) {
                  setState(() {
                    _image = image;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, submit data
                    print('Selected radio value: $_selectedRadioValue');
                    print('Selected checkboxes: $_selectedCheckboxes');
                    print('Entered text: ${_textFieldController.text}');
                    print('Selected dropdown value: $_selectedDropdownValue');
                    // You can handle image upload here
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RadioGroup extends StatelessWidget {
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const RadioGroup({
    required this.options,
    required this.onChanged,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options
          .map(
            (option) => Row(
              children: [
                Radio<String?>(
                  value: option,
                  groupValue: selectedValue,
                  onChanged: onChanged,
                ),
                Text(option),
              ],
            ),
          )
          .toList(),
    );
  }
}

class CheckboxGroup extends StatelessWidget {
  final List<String> options;
  final List<String> selectedValues;
  final ValueChanged<List<String>> onChanged;

  const CheckboxGroup({
    required this.options,
    required this.selectedValues,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options
          .map(
            (option) => Row(
              children: [
                Checkbox(
                  value: selectedValues.contains(option),
                  onChanged: (isChecked) {
                    List<String> updatedValues = List.from(selectedValues);
                    if (isChecked!) {
                      updatedValues.add(option);
                    } else {
                      updatedValues.remove(option);
                    }
                    onChanged(updatedValues);
                  },
                ),
                Text(option),
              ],
            ),
          )
          .toList(),
    );
  }
}

class ImageUploader extends StatelessWidget {
  final File? image;
  final ValueChanged<File?> onImageSelected;

  const ImageUploader({
    Key? key,
    required this.image,
    required this.onImageSelected,
  }) : super(key: key);

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      onImageSelected(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: image != null
            ? Image.file(
                image!,
                fit: BoxFit.cover,
              )
            : const Center(
                child: Icon(Icons.cloud_upload, size: 50),
              ),
      ),
    );
  }
}
