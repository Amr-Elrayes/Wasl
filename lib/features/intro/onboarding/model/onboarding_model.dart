
import 'package:wasl/core/constants/app_images.dart';

class OnBoardingModel {
  final String image;
  final String title;
  final String subtitle;

  OnBoardingModel({
    required this.image,
    required this.title,
    required this.subtitle,
      });

      static List<OnBoardingModel> onBoardingScreens = [
        OnBoardingModel(
          image: AppImages.on1,
          title: 'Search for a suitable job',
          subtitle:
              'Search for jobs suitable for you and apply to them easily',
        ),
        OnBoardingModel(
          image: AppImages.on2,
          title: 'Post a job',
          subtitle: 'Publish a job announcement and search for the best candidates',
        ),
        OnBoardingModel(
          image: AppImages.on3,
          title: 'Safe and secure',
          subtitle: "Rest assured that your privacy and security are our top priorities",
        ),
      ];
    }

