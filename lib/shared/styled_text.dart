import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/theme.dart';

class StyledBodyText extends StatelessWidget {
  const StyledBodyText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.poppins(
        textStyle: TextStyle(color: Colors.grey[800]),
      )
    );
  }
}
class StyledBodyText2 extends StatelessWidget {
  const StyledBodyText2(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.poppins(
        textStyle: TextStyle(color: Colors.blue[500], fontSize: 18),
      )
    );
  }
}

class StyledHeading extends StatelessWidget {
  const StyledHeading(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.poppins(
        textStyle: TextStyle(color: Colors.blue[500], fontSize: 32, fontWeight: FontWeight.w500),
      )
    );
  }
}
class StyledBookHeadingText extends StatelessWidget {
  const StyledBookHeadingText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.poppins(
        textStyle: TextStyle(color: Colors.blue[500], fontSize: 14.5),
      )
    );
  }
}
class StyledBookAuthorText extends StatelessWidget {
  const StyledBookAuthorText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 14),
      )
    );
  }
}
class StyledBookConditionText extends StatelessWidget {
  const StyledBookConditionText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 13, color: AppColors.primaryColor),
      )
    );
  }
}
class StyledBookConditionSecondaryText extends StatelessWidget {
  const StyledBookConditionSecondaryText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 13, color: Colors.blue[500], fontWeight: FontWeight.bold),
      )
    );
  }
}

class StyledAppBarText extends StatelessWidget {
  const StyledAppBarText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.poppins(
        textStyle: TextStyle(color: Colors.blue[500], fontSize: 18, fontWeight: FontWeight.bold),
      )
    );
  }
}

class StyledErrorText extends StatelessWidget {
  const StyledErrorText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.poppins(
        textStyle: const TextStyle(color: Colors.red),
      )
    );
  }
}