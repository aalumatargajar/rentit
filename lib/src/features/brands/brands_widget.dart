import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rentit/src/common/const/global_variable.dart';
import 'package:rentit/src/common/model/brands_model.dart';
import 'package:shimmer/shimmer.dart';

class BrandsWidget {
  static Container gridBrandsView({
    required BuildContext context,
    required BrandsModel brand,
    required Function() onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                child: CachedNetworkImage(
                  imageUrl: brand.logoUrl,
                  fit: BoxFit.fitHeight,
                  width: double.infinity,
                  placeholder:
                      (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(color: Colors.grey[300]),
                      ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              brand.name,
              style: txtTheme(context).titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
