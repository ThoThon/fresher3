import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FooterButton extends StatelessWidget {
  final String svgAsset;
  final String label;
  final VoidCallback onTap;

  const FooterButton({
    super.key,
    required this.svgAsset,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 50,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDECE9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset(svgAsset),
                  ),
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
