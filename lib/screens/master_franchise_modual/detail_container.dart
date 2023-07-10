import 'package:employee_app/models/user_model.dart';
import 'package:flutter/material.dart';

class DetailContainer extends StatelessWidget {
  final Size size;
  final UserModel data;
  final Function onTap;
  final int index;
  final String? status;
  final Color? color;

  const DetailContainer(
      {Key? key,
      required this.size,
      required this.data,
      required this.onTap,
      required this.index,
      this.status,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 15),
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFF5F5F5),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 2, spreadRadius: 2),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width * 0.68,
                  child: Text(
                    "${data.userFname ?? ""} ${data.userLname ?? ""}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  "📞 +91 ${data.userMobileno1}   \n@  ${data.userEmail}",
                  style: TextStyle(
                    fontSize: size.width * 0.034,
                  ),
                ),
                Text(
                  "📍 ${data.userDistrict}, ${data.cityName}, ${data.stateName}",
                  style: TextStyle(
                    fontSize: size.width * 0.034,
                  ),
                ),
              ],
            ),
          ),
          if (status != null)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                color: color ?? Colors.orange,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: Text(
                status!,
                style: TextStyle(
                  fontSize: size.width * 0.035,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
