// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
//     return ScreenUtilInit(
//       designSize: const Size(360, 690),
//       minTextAdapt: true,
//       enableScaleText: () {
//         return true;
//       },
//       splitScreenMode: true,
//       // Use builder only if you need to use library outside ScreenUtilInit context
//       builder: (_, child) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'First Method',
//           // You can use the library anywhere in the app even in theme
//           // theme: ThemeData(
//           //   primarySwatch: Colors.blue,
//           //   textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
//           // ),
//           home: child,
//         );
//       },
//       child: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text('Enhanced Content Screen'),
//         elevation: 2,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Section
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(16.w),
//               color: Colors.blue[50],
//               child: Column(
//                 children: [
//                   // ClipRRect(
//                   //   borderRadius: BorderRadius.circular(12.w),
//                   //   child: Image.network(
//                   //     'https://via.placeholder.com/360x250',
//                   //     width: 360.w,
//                   //     height: 250.h,
//                   //     fit: BoxFit.cover,
//                   //   ),
//                   // ),
//                   SizedBox(height: 16.h),
//                   Text(
//                     'Welcome to Our App',
//                     style: TextStyle(
//                       fontSize: 32.sp,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue[800],
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   Text(
//                     'Discover a world of features tailored just for you.',
//                     style: TextStyle(fontSize: 18.sp, color: Colors.grey[700]),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 16.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 20.w,
//                             vertical: 12.h,
//                           ),
//                         ),
//                         onPressed: () {},
//                         child: Text(
//                           'Get Started',
//                           style: TextStyle(fontSize: 16.sp),
//                         ),
//                       ),
//                       SizedBox(width: 16.w),
//                       OutlinedButton(
//                         style: OutlinedButton.styleFrom(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 20.w,
//                             vertical: 12.h,
//                           ),
//                         ),
//                         onPressed: () {},
//                         child: Text(
//                           'Learn More',
//                           style: TextStyle(fontSize: 16.sp),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 24.h),
//             // Highlight Section
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Highlights',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 24.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 12.h),
//                   Row(
//                     children: [
//                       const Expanded(
//                         child: HighlightTile(
//                           title: 'Quick Access',
//                           subtitle: 'Reach your goals faster.',
//                           icon: Icons.flash_on,
//                         ),
//                       ),
//                       SizedBox(width: 16.w),
//                       const Expanded(
//                         child: HighlightTile(
//                           title: 'Customizable',
//                           subtitle: 'Make it your own.',
//                           icon: Icons.settings,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 24.h),
//             // Features Section
//             Container(
//               color: Colors.white,
//               padding: EdgeInsets.all(16.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Key Features',
//                     style: TextStyle(
//                       fontSize: 24.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 12.h),
//                   Row(
//                     children: [
//                       const Expanded(
//                         child: FeatureContainer(
//                           icon: Icons.speed,
//                           title: 'Fast Performance',
//                           description:
//                               'Experience lightning-fast speed with optimized processing.',
//                         ),
//                       ),
//                       SizedBox(width: 16.w),
//                       const Expanded(
//                         child: FeatureContainer(
//                           icon: Icons.thumb_up,
//                           title: 'User Friendly',
//                           description:
//                               'Designed with simplicity and ease of use in mind.',
//                         ),
//                       ),
//                       SizedBox(width: 16.w),
//                       const Expanded(
//                         child: FeatureContainer(
//                           icon: Icons.lock,
//                           title: 'Secure',
//                           description:
//                               'Top-notch security to keep your data safe.',
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 24.h),
//             // Testimonials Section
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'What Users Say',
//                     style: TextStyle(
//                       fontSize: 24.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 12.h),
//                   const TestimonialCard(
//                     name: 'Jane Doe',
//                     comment:
//                         'This app has transformed how I manage my daily tasks!',
//                     rating: 5,
//                   ),
//                   SizedBox(height: 12.h),
//                   const TestimonialCard(
//                     name: 'John Smith',
//                     comment: 'Incredible performance and super intuitive.',
//                     rating: 4,
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 24.h),
//             // Content Grid Section
//             Container(
//               padding: EdgeInsets.all(16.w),
//               color: Colors.grey[200],
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Explore More',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 24.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 12.h),
//                   GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       mainAxisSpacing: 16.h,
//                       crossAxisSpacing: 16.w,
//                       childAspectRatio: 0.75,
//                     ),
//                     itemCount: 8,
//                     itemBuilder: (context, index) {
//                       return Card(
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12.w),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // ClipRRect(
//                             //   borderRadius: BorderRadius.vertical(
//                             //     top: Radius.circular(12.w),
//                             //   ),
//                             //   child: Image.network(
//                             //     'https://via.placeholder.com/150x120',
//                             //     width: double.infinity,
//                             //     height: 120.h,
//                             //     fit: BoxFit.cover,
//                             //   ),
//                             // ),
//                             Padding(
//                               padding: EdgeInsets.all(8.w),
//                               child: Text(
//                                 'Topic ${index + 1}',
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 18.sp,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 8.w),
//                               child: Text(
//                                 'A brief overview of topic ${index + 1} with key insights.',
//                                 style: TextStyle(
//                                   fontSize: 14.sp,
//                                   color: Colors.black,
//                                 ),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 24.h),
//             // Footer Section
//             Container(
//               color: Colors.blueGrey[900],
//               padding: EdgeInsets.all(20.w),
//               child: Column(
//                 children: [
//                   Text(
//                     'Stay Connected',
//                     style: TextStyle(
//                       fontSize: 20.sp,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(height: 12.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.facebook, size: 24.w, color: Colors.white),
//                       SizedBox(width: 20.w),
//                       Icon(Icons.face, size: 24.w, color: Colors.white),
//                       SizedBox(width: 20.w),
//                       Icon(Icons.settings, size: 24.w, color: Colors.white),
//                       SizedBox(width: 20.w),
//                       Icon(Icons.waves, size: 24.w, color: Colors.white),
//                     ],
//                   ),
//                   SizedBox(height: 16.h),
//                   Text(
//                     '© 2023 My Company. All rights reserved.',
//                     style: TextStyle(fontSize: 14.sp, color: Colors.white70),
//                   ),
//                   SizedBox(height: 8.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       TextButton(
//                         onPressed: () {},
//                         child: Text(
//                           'Privacy Policy',
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             color: Colors.white70,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 16.w),
//                       TextButton(
//                         onPressed: () {},
//                         child: Text(
//                           'Terms of Service',
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             color: Colors.white70,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FeatureContainer extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String description;

//   const FeatureContainer({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.description,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Colors.blue[50],
//         borderRadius: BorderRadius.circular(12.w),
//         border: Border.all(color: Colors.blue[200]!),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 48.w, color: Colors.blue[700]),
//           SizedBox(height: 8.h),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 20.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.blue[800],
//             ),
//           ),
//           SizedBox(height: 4.h),
//           Text(
//             description,
//             style: TextStyle(fontSize: 14.sp, color: Colors.grey[800]),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class HighlightTile extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final IconData icon;

//   const HighlightTile({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(12.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8.w),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Icon(icon, size: 32.w, color: Colors.orange),
//           SizedBox(width: 8.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child: Text(
//                     subtitle,
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: Colors.grey[600],
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TestimonialCard extends StatelessWidget {
//   final String name;
//   final String comment;
//   final int rating;

//   const TestimonialCard({
//     super.key,
//     required this.name,
//     required this.comment,
//     required this.rating,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.w),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: List.generate(
//               5,
//               (index) => Icon(
//                 index < rating ? Icons.star : Icons.star_border,
//                 size: 20.w,
//                 color: Colors.yellow[700],
//               ),
//             ),
//           ),
//           SizedBox(height: 8.h),
//           Text(
//             '"$comment"',
//             style: TextStyle(
//               fontSize: 16.sp,
//               fontStyle: FontStyle.italic,
//               color: Colors.grey[800],
//             ),
//           ),
//           SizedBox(height: 8.h),
//           Text(
//             '- $name',
//             style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
// }
