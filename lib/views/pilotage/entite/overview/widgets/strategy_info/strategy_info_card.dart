import 'package:flutter/material.dart';
import '../../../../../../constants/constant_double.dart';
import '../../../../../../helper/responsive.dart';
import 'pilier_model.dart';
import 'pilier_info_card.dart';

class StrategyInfoCard extends StatelessWidget {
  const StrategyInfoCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Les Axes Stratégiques",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: defaultPadding),
        Responsive(
          mobile: PilierInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 ? 1.3 : 1,
          ),
          tablet: const PilierInfoCardGridView(),
          desktop: PilierInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class PilierInfoCardGridView extends StatefulWidget {
  const PilierInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  State<PilierInfoCardGridView> createState() => _PilierInfoCardGridViewState();
}

class _PilierInfoCardGridViewState extends State<PilierInfoCardGridView> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: demoPiliers.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemBuilder: (context, index) => PilierInfoCard(info: demoPiliers[index],annee: DateTime.now().year,),
    );
  }
}
