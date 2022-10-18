import 'package:flutter/material.dart';

class DataColumnSearch extends StatefulWidget {
  final String title;
  final void Function(String?) onFilterChange;
  final String filter;

  const DataColumnSearch({
    Key? key,
    required this.title,
    required this.onFilterChange,
    required this.filter,
  }) : super(key: key);

  @override
  State<DataColumnSearch> createState() => _DataColumnSearchState();
}

class _DataColumnSearchState extends State<DataColumnSearch> {
  double size = 18;
  var textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController.text = widget.filter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late Color iconColor;
    switch (MediaQuery.of(context).platformBrightness) {
      case Brightness.dark:
        iconColor = Theme.of(context).primaryColorDark;
        break;
      case Brightness.light:
        iconColor = Theme.of(context).primaryColorLight;
        break;
    }

    return Row(
      children: [
        Text(widget.title),
        PopupMenuButton<String>(
          icon: Icon(
            Icons.search,
            color: widget.filter.isNotEmpty ? iconColor : null,
          ),
          iconSize: size,
          splashRadius: size,
          tooltip: 'Filtro',
          itemBuilder: (context) => [
            PopupMenuItem(
              padding: const EdgeInsets.all(0),
              value: textEditingController.text,
              child: SizedBox(
                width: 350,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintText: 'CERCA',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      splashRadius: size,
                      iconSize: size,
                      onPressed: () {
                        if (textEditingController.text.isNotEmpty) {
                          widget.onFilterChange(textEditingController.text);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.cancel),
                      splashRadius: size,
                      iconSize: size,
                      onPressed: () {
                        if (textEditingController.text.isNotEmpty) {
                          textEditingController.clear();
                          widget.onFilterChange(null);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
