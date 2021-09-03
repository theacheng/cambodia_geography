import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/widgets_exports.dart';
import 'package:cambodia_geography/helpers/app_helper.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/screens/map/map_screen.dart';
import 'package:cambodia_geography/widgets/cg_text_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceTitle extends StatelessWidget {
  const PlaceTitle({
    Key? key,
    required this.title,
    this.subtitle,
    required this.provinceCode,
    required this.lat,
    required this.lon,
    this.loading = false,
    this.place,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final String? provinceCode;
  final double? lat;
  final double? lon;
  final bool loading;
  final PlaceModel? place;

  @override
  Widget build(BuildContext context) {
    CambodiaGeography geo = CambodiaGeography.instance;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    TbProvinceModel province = geo.tbProvinces.firstWhere((province) => province.code == provinceCode);

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.all(ConfigConstant.margin2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitle(textTheme, colorScheme),
          buildSubtitle(colorScheme, province, textTheme),
          if (!loading) buildMainButtons(colorScheme, context),
        ],
      ),
    );
  }

  Widget buildTitle(TextTheme textTheme, ColorScheme colorScheme) {
    if (loading) return CgTextShimmer();
    return Text(
      title,
      style: textTheme.headline6?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w700),
    );
  }

  Widget buildSubtitle(ColorScheme colorScheme, TbProvinceModel province, TextTheme textTheme) {
    if (loading) return CgTextShimmer(height: 12, width: 200);
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: ConfigConstant.iconSize1,
          color: colorScheme.primary,
        ),
        Text(
          subtitle ?? '${province.khmer}',
          style: textTheme.bodyText2?.copyWith(color: textTheme.caption?.color),
        ),
      ],
    );
  }

  Widget buildMainButtons(
    ColorScheme colorScheme,
    BuildContext context,
  ) {
    LatLng? latLng;
    bool isLatLngValdated = false;
    if (lat != null || lon != null) {
      isLatLngValdated = AppHelper.isLatLngValdated(lat!, lon!);
    }

    if (!isLatLngValdated) {
      return const SizedBox(height: ConfigConstant.margin0);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CgButton(
          labelText: 'ទិសដៅ',
          iconData: Icons.map,
          foregroundColor: colorScheme.secondary,
          backgroundColor: colorScheme.secondary.withOpacity(0.1),
          showBorder: true,
          onPressed: () {
            latLng = LatLng(lat!, lon!);
            Navigator.of(context).pushNamed(
              RouteConfig.MAP,
              arguments: MapScreenSetting(
                flowType: MapFlowType.view,
                initialLatLng: latLng,
                place: place,
              ),
            );
          },
        ),
      ],
    );
  }
}
