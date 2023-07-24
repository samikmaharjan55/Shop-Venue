import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_venue/model/product.dart';
import 'package:shop_venue/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = "/edit_product_screen";
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imgUrlFocusNode = FocusNode();
  final _imgUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _isInit = true;
  bool _isLoading = false;

  var _editedProduct =
      Product(id: "", title: "", price: 0, description: "", imageURL: "");

  var initValues = {
    'title': "",
    'price': '',
    'description': "",
    'imageURL': ""
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imgUrlFocusNode.addListener(_updateImageUrl);
  }

  void _updateImageUrl() {
    if (!_imgUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imgUrlFocusNode.dispose();
    _imgUrlController.dispose();
  }

  // save form and validate
  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id.isNotEmpty) {
      try {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("Error Occurred"),
                  content: const Text(
                      'Something has occurred! Product could not be added'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ));
      }
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("Error Occurred"),
                  content: const Text(
                      'Something has occurred! Product could not be added'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ));
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      final String? productId =
          ModalRoute.of(context)?.settings.arguments as String?;

      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageURL': _editedProduct.imageURL,
        };
        _imgUrlController.text = _editedProduct.imageURL;
      }
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _editedProduct.id.isNotEmpty
            ? const Text('Edit Product')
            : const Text('Add Product'),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    initialValue: initValues["title"],
                    decoration: const InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'The title must not be empty.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value!.trimLeft().trim(),
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageURL: _editedProduct.imageURL);
                    },
                  ),
                  TextFormField(
                    initialValue: initValues["price"],
                    decoration: const InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_descFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'The price must not be empty.';
                      }
                      if (double.tryParse(value) == null) {
                        return 'The price must be in a number format';
                      }
                      if (double.parse(value) <= 0) {
                        return 'The price should not be less than zero';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          price: double.parse(value!),
                          description: _editedProduct.description,
                          imageURL: _editedProduct.imageURL);
                    },
                  ),
                  TextFormField(
                    initialValue: initValues["description"],
                    decoration: const InputDecoration(labelText: 'Description'),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    focusNode: _descFocusNode,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'The description must not be empty.';
                      }
                      if (value.length < 10) {
                        return 'The description must be at least 10 characters';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: value!.trimLeft().trim(),
                          imageURL: _editedProduct.imageURL);
                    },
                  ),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(
                          top: 8,
                          right: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: _imgUrlController.text.isEmpty
                            ? const Center(child: Text('Enter a URL'))
                            : FittedBox(
                                child: Image.network(
                                  _imgUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Image Url'),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          focusNode: _imgUrlFocusNode,
                          controller: _imgUrlController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'The image url must not be empty.';
                            }
                            if (!value.startsWith("http") &&
                                !value.startsWith("https")) {
                              return 'The image url is not valid.';
                            }
                            if (!value.endsWith(".png") &&
                                !value.endsWith(".jpg") &&
                                !value.endsWith(".jpeg") &&
                                !value.endsWith(".JPG")) {
                              return 'The image url is not correct';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageURL: value!.trim());
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
