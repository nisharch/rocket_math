
import 'package:flutter/material.dart';

class SubtractionLearnScreen extends StatefulWidget {
  const SubtractionLearnScreen({super.key});

  @override
  State<SubtractionLearnScreen> createState() => _SubtractionLearnScreenState();
}

class _SubtractionLearnScreenState extends State<SubtractionLearnScreen> {
  // ২ নম্বর সেকশনের ম্যাঙ্গো মাঞ্চার গেমের জন্য ভেরিয়েবল
  int totalMangoes = 5;
  int eatenMangoes = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: const Text("➖ Subtraction Lab"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // কার্টুন রোবট গাইড মাসকট
          _buildHeaderMascot(),
          const SizedBox(height: 20),

          // ১. সাবট্র্যাকশন পরিচিতি (What is Subtraction)
          _buildLearnCard(
            title: "1. What is Subtraction? 🤔",
            content: "Subtraction means TAKING AWAY! 🎒\n"
                     "When we remove things from a group, we do subtraction. "
                     "We use Minus (−) sign, and the leftover is called Difference! 🌟",
            bgColor: Colors.orange.shade50,
            borderColor: Colors.orange,
            childWidget: _buildIntroStarsDiagram(),
          ),

          // ২. ইন্টারেক্টিভ আম খাওয়ার গেম সেকশন (Mango Muncher)
          _buildLearnCard(
            title: "2. The Mango Muncher! 🥭",
            content: "Click 'Eat One' to eat a mango and subtract it! Click 'Undo' to get it back!",
            bgColor: Colors.yellow.shade50,
            borderColor: Colors.amber,
            childWidget: _buildMangoMuncherGame(),
          ),

          // ৩. কীভাবে সাধারণ বিয়োগ করতে হয় (Normal Subtraction)
          _buildLearnCard(
            title: "3. How to Subtract? 👣",
            content: "Let's do 35 − 12. Always start from the friendly ONES side first!",
            bgColor: Colors.green.shade50,
            borderColor: Colors.green,
            childWidget: _buildNormalSubDiagram(),
          ),

          // ৪. ক্যারি ওভার বা ধার করার বিয়োগ (Borrowing)
          _buildLearnCard(
            title: "4. The Carry Over Magic! ⚡",
            content: "Let's do 42 − 17. Since 2 is smaller than 7, borrow 1 Ten from the neighbor house!",
            bgColor: Colors.purple.shade50,
            borderColor: Colors.purple,
            childWidget: _buildBorrowSubDiagram(),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // কার্টুন রোবট গাইড মাসকট
  Widget _buildHeaderMascot() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: Colors.redAccent.withOpacity(0.2), width: 2),
      ),
      child: Row(
        children: [
          const Text("🤖", style: TextStyle(fontSize: 45)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Robo-Math Subtraction! ⚡", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                SizedBox(height: 2),
                Text("Let's do some funny takeaway missions!", style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // বেস কার্ড উইজেট যা হোভার ও টাচ অ্যানিমেশন সাপোর্ট করে
  Widget _buildLearnCard({required String title, required String content, required Color bgColor, required Color borderColor, required Widget childWidget}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(color: borderColor.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: borderColor)),
          const SizedBox(height: 6),
          Text(content, style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.black87, fontWeight: FontWeight.w500)),
          childWidget,
        ],
      ),
    );
  }

  // ১ নম্বর কার্ডের স্টার ডায়াগ্রাম
  Widget _buildIntroStarsDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("⭐⭐⭐⭐⭐", style: TextStyle(fontSize: 16)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text("−", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
          ),
          Text("⭐⭐", style: TextStyle(fontSize: 16)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text("=", style: TextStyle(fontSize: 18, color: Colors.black38)),
          ),
          Text("⭐⭐⭐", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // ২ নম্বর সেকশনের ইন্টারেক্টিভ আম খাওয়ার গেম (Mango Muncher)
  Widget _buildMangoMuncherGame() {
    int currentMangoes = totalMangoes - eatenMangoes;
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          // আমের ডিসপ্লে
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              currentMangoes > 0 ? "🥭" * currentMangoes : "Empty Basket! 🧺",
              key: ValueKey<int>(currentMangoes),
              style: const TextStyle(fontSize: 28),
            ),
          ),
          const SizedBox(height: 10),
          // ডাইনামিক গেম স্কোর টেক্সট
          Text(
            "$totalMangoes − $eatenMangoes = $currentMangoes",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.orangeAccent),
          ),
          const SizedBox(height: 12),
          // গেম বাটন কন্ট্রোল
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ).buildElevatedButton(
                onPressed: eatenMangoes < totalMangoes
                    ? () => setState(() => eatenMangoes++)
                    : null,
                child: const Text("Eat One 🍽️", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ).buildElevatedButton(
                onPressed: eatenMangoes > 0
                    ? () => setState(() => eatenMangoes--)
                    : null,
                child: const Text("Undo 🔄", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          )
        ],
      ),
    );
  }

  // ৩ নম্বর কার্ডের সাধারণ বিয়োগের ডায়াগ্রাম (35 - 12 = 23)
  Widget _buildNormalSubDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 30),
              Text("T", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent)),
              SizedBox(width: 40),
              Text("O", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
            ],
          ),
          const Divider(height: 6, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 30),
              Text("3", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(width: 40),
              Text("5", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("−", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
              SizedBox(width: 15),
              Text("1", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(width: 40),
              Text("2", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          Container(margin: const EdgeInsets.symmetric(vertical: 4), height: 2, width: 110, color: Colors.black87),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 30),
              Text("2", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.green)),
              SizedBox(width: 40),
              Text("3", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  // ৪ নম্বর কার্ডের জন্য ক্যারি/ধার করার বিয়োগের ডায়াগ্রাম (42 - 17 = 25)
  Widget _buildBorrowSubDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 25),
              Text("(3)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple.shade300)),
              const SizedBox(width: 30),
              Text("(12)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple.shade300)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 30),
              Text("T", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent)),
              SizedBox(width: 40),
              Text("O", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
            ],
          ),
          const Divider(height: 6, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 30),
              Text("4", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough, decorationColor: Colors.red)),
              SizedBox(width: 40),
              Text("2", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough, decorationColor: Colors.red)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("−", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple)),
              SizedBox(width: 15),
              Text("1", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(width: 40),
              Text("7", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          Container(margin: const EdgeInsets.symmetric(vertical: 4), height: 2, width: 110, color: Colors.black87),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 30),
              Text("2", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.purple)),
              SizedBox(width: 40),
              Text("5", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.purple)),
            ],
          ),
        ],
      ),
    );
  }
}

// ElevatedButton এর জন্য এক্সটেনশন মেথড (কোড ক্লিন রাখার জন্য)
extension on ButtonStyle {
  Widget buildElevatedButton({required VoidCallback? onPressed, required Widget child}) {
    return ElevatedButton(
      style: this,
      onPressed: onPressed,
      child: child,
    );
  }
}