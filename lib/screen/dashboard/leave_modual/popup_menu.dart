import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../helper/app_colors.dart';
import '../../../helper/navigations.dart';
import '../../../models/leave_model.dart';
import '../../../view model/CustomViewModel.dart';
import '../../widgets/custom_widgets.dart';

class PopupMenuItems extends StatefulWidget {
  final Leave data;

  const PopupMenuItems({Key? key, required this.data}) : super(key: key);

  @override
  State<PopupMenuItems> createState() => _PopupMenuItemsState();
}

class _PopupMenuItemsState extends State<PopupMenuItems> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PopupMenuButton<int>(
      tooltip: '',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon: const Icon(Icons.more_vert, color: Colors.black54),
      color: AppColors.primary,
      itemBuilder: (context) => [
        const PopupMenuItem(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
          ),
          height: 1,
          child: SizedBox(height: 1),
        ),
        popupMenu(
            value: 1,
            name: 'Approve Leave',
            size: size,
            onTap: () {
              pop(context);
              popup(
                  size: size,
                  context: context,
                  title: "Are you sure want to Approve your leave?",
                  onYesTap: () async {
                    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
                    await state.deleteLeave(widget.data.leavedeliveryID ?? "", "1");
                  });
            }),
        popupMenu(
            value: 2,
            name: 'Cancel Leave',
            size: size,
            onTap: () {
              pop(context);
              popup(
                  size: size,
                  context: context,
                  title: "Are you sure want to cancel your leave?",
                  onYesTap: () async {
                    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
                    await state.deleteLeave(widget.data.leavedeliveryID ?? "", "2");
                  });
            }),
      ],
    );
  }

  PopupMenuItem<int> popupMenu({
    required String name,
    required Size size,
    required Function onTap,
    required int value,
  }) {
    return PopupMenuItem(
      value: value,
      height: 8,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          color: Colors.transparent,
          width: double.infinity,
          child: Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.045,
            ),
          ),
        ),
      ),
    );
  }
}
