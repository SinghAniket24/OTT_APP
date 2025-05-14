import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';

class ContactPage extends StatefulWidget {
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _companyNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();

  final _titleController = TextEditingController();
  final _genreController = TextEditingController();
  final _durationController = TextEditingController();
  final _synopsisController = TextEditingController();
  final _trailerController = TextEditingController();

  PlatformFile? _videoFile;

  @override
  void dispose() {
    _companyNameController.dispose();
    _contactPersonController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _titleController.dispose();
    _genreController.dispose();
    _durationController.dispose();
    _synopsisController.dispose();
    _trailerController.dispose();
    super.dispose();
  }

  Future<void> _pickVideoFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'mov', 'avi'],
      withData: true,
    );
    if (result != null && result.files.single.size <= 500 * 1024 * 1024) {
      setState(() {
        _videoFile = result.files.single;
      });
    } else if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File too large. Max 500MB allowed.')),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_videoFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please upload a sample video.')),
        );
        return;
      }
      // TODO: Implement your form submission logic here.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form submitted!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black.withOpacity(0.7),
        elevation: 8,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        shadowColor: Colors.tealAccent.withOpacity(0.3),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF116466), Color(0xFF191A1E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    "Want your movie or series featured on our platform? Fill out this form and our content team will review your submission.",
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.88),
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _companyInfoCard()),
                            SizedBox(width: 20),
                            Expanded(child: _contentDetailsCard()),
                          ],
                        )
                      : Column(
                          children: [
                            _companyInfoCard(),
                            SizedBox(height: 20),
                            _contentDetailsCard(),
                          ],
                        ),
                ),
                SizedBox(height: 32),
                SizedBox(
                  width: 220,
                  child: ElevatedButton.icon(
                    onPressed: _submitForm,
                    icon: Icon(Icons.send_rounded, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF116466),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shadowColor: Colors.tealAccent,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    label: Text(
                      'Submit',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _companyInfoCard() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.business_rounded,
            title: 'Company Information',
            color: Colors.tealAccent,
          ),
          SizedBox(height: 12),
          _buildTextField(
            controller: _companyNameController,
            label: "Company Name*",
            icon: Icons.apartment_rounded,
            validator: (v) => v!.isEmpty ? "Required" : null,
          ),
          _buildTextField(
            controller: _contactPersonController,
            label: "Contact Person*",
            icon: Icons.person_outline_rounded,
            validator: (v) => v!.isEmpty ? "Required" : null,
          ),
          _buildTextField(
            controller: _emailController,
            label: "Email*",
            icon: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return "Required";
              final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
              if (!emailRegex.hasMatch(v)) return "Enter a valid email";
              return null;
            },
          ),
          _buildTextField(
            controller: _phoneController,
            label: "Phone",
            icon: Icons.phone_rounded,
            keyboardType: TextInputType.phone,
          ),
          _buildTextField(
            controller: _websiteController,
            label: "Website",
            hint: "https://",
            icon: Icons.language_rounded,
            keyboardType: TextInputType.url,
          ),
        ],
      ),
    );
  }

  Widget _contentDetailsCard() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.movie_creation_rounded,
            title: 'Content Details',
            color: Colors.amberAccent,
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _titleController,
                  label: "Title*",
                  icon: Icons.title_rounded,
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _genreController,
                  label: "Genre*",
                  icon: Icons.category_rounded,
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _buildTextField(
                  controller: _durationController,
                  label: "Duration*",
                  hint: "e.g. 120 min",
                  icon: Icons.timer_rounded,
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
              ),
            ],
          ),
          _buildTextField(
            controller: _synopsisController,
            label: "Synopsis*",
            icon: Icons.description_rounded,
            maxLines: 4,
            validator: (v) => v!.isEmpty ? "Required" : null,
          ),
          _buildTextField(
            controller: _trailerController,
            label: "Trailer Link (YouTube/Vimeo)",
            hint: "https://",
            icon: Icons.link_rounded,
            keyboardType: TextInputType.url,
          ),
          SizedBox(height: 16),
          _uploadVideoCard(),
        ],
      ),
    );
  }

  Widget _uploadVideoCard() {
    return GestureDetector(
      onTap: _pickVideoFile,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 22, horizontal: 12),
        decoration: BoxDecoration(
          color: Color(0xFF191A1E).withOpacity(0.85),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _videoFile == null ? Colors.tealAccent : Colors.greenAccent,
            width: 2,
          ),
          boxShadow: [
            if (_videoFile != null)
              BoxShadow(
                color: Colors.greenAccent.withOpacity(0.18),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              _videoFile == null ? Icons.cloud_upload_rounded : Icons.check_circle_rounded,
              color: _videoFile == null ? Colors.tealAccent : Colors.greenAccent,
              size: 36,
            ),
            SizedBox(height: 8),
            Text(
              _videoFile == null
                  ? 'Click to upload video file'
                  : _videoFile!.name,
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.92),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "MP4, MOV or AVI. Max 500MB.",
              style: GoogleFonts.poppins(
                color: Color(0xFFB2B2B2),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.09),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.tealAccent.withOpacity(0.14), width: 1.2),
      ),
      child: child,
    );
  }

  Widget _sectionHeader({required IconData icon, required String title, required Color color}) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 19,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.white),
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: Colors.tealAccent) : null,
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Color(0xFFB2B2B2)),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.tealAccent.withOpacity(0.7)),
          filled: true,
          fillColor: Color(0xFF262A34).withOpacity(0.96),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        ),
      ),
    );
  }
}
