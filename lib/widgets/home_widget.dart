import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/transactionCompletion_page.dart';
import 'package:my_app/utils/smartcontractInteractions.dart';
import 'package:web3dart/crypto.dart';

class HomeWidget extends StatefulWidget {
  final connector, uri, connectedAddress;
  const HomeWidget(
      {Key? key,
      required this.connector,
      required this.uri,
      required this.connectedAddress})
      : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  String name = "";
  String upi = "";
  String newAddress = "";

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Top Features"),
          const SizedBox(height: 5),
          SizedBox(
            height: 200,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          onTapLinkUPI(context);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/link_UPI.png",
                              width: 40,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Link UPI",
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          onTapChangeAddress(context);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/transferaccount_icon.png",
                              width: 40,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Change Address",
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/transactionhistory_icon.png",
                              width: 40,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Tx History",
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> onTapLinkUPI(BuildContext context) async {
    final key = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Link your UPI",
              style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.headline2!.fontFamily,
                  fontSize: 16),
            ),
            content: Container(
              padding: const EdgeInsets.all(10),
              child: linkUPIForm(key),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    if (key.currentState!.validate()) {
                      String txHash = await linkUPI(widget.connector,
                          widget.uri, widget.connectedAddress, upi, name);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => TransactionCompletionPage(
                                  txHash: txHash, isCryptoTransfer: false)));
                    }
                  },
                  child: const Text("Link"))
            ],
          );
        });
  }

  Future<void> onTapChangeAddress(BuildContext context) async {
    final key = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Change linked address",
              style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.headline2!.fontFamily,
                  fontSize: 16),
            ),
            content: Container(
              padding: const EdgeInsets.all(10),
              child: changeAddressForm(key),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    if (key.currentState!.validate()) {
                      String txHash = await changeAddress(widget.connector,
                          widget.uri, widget.connectedAddress, upi, newAddress);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => TransactionCompletionPage(
                                  txHash: txHash, isCryptoTransfer: false)));
                    }
                  },
                  child: const Text("Change Address"))
            ],
          );
        });
  }

  Form linkUPIForm(GlobalKey<FormState> formKey) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            onChanged: (value) => setState(() {
              name = value;
            }),
            validator: (String? value) {
              return (value!.isEmpty) ? "Name can't be empty" : null;
            },
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: "Enter Name",
                labelText: "Enter Name"),
          ),
          const SizedBox(height: 10),
          TextFormField(
            onChanged: ((value) => setState(() {
                  upi = value;
                })),
            validator: (String? value) {
              return (value!.isEmpty || !value.contains('@'))
                  ? "Not valid UPI Id"
                  : null;
            },
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: "Enter your UPI",
                labelText: "Enter your UPI"),
          )
        ],
      ),
    );
  }

  Form changeAddressForm(GlobalKey<FormState> formKey) {
    return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              onChanged: ((value) => setState(() {
                    upi = value;
                  })),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Enter registered UPI",
                  labelText: "Enter registered UPI"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              onChanged: ((value) => setState(() {
                    newAddress = value;
                  })),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Enter new receiving address",
                  labelText: "Enter new receiving address"),
            )
          ],
        ));
  }
}
