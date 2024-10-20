import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/Data/Local/DB_helper.dart';
import 'package:notesapp/Model/NotesModel.dart';

import 'AddNotePage.dart';

class NotesHomePage extends StatefulWidget {
  const NotesHomePage({super.key});

  @override
  State<NotesHomePage> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {

  final TextEditingController searchController = TextEditingController();



  @override
  void initState() {
    super.initState();
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes',style: TextStyle(color: Colors.white),),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,

      ),
      body:
      FutureBuilder(future: DbHelper().readData(), builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
         if(!snapshot.hasData){
        return   const Center(
        child: CircularProgressIndicator()
        );
        }
         else if(snapshot.data!.isEmpty){
          return   const Center(
            child: Text(
              'No Notes Yet!!!',
              style: TextStyle(fontSize: 21, color: Colors.grey),
            ),
          );
        }
         if (snapshot.hasData){
          return SingleChildScrollView(
            child: Column(
              children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchController,
              onChanged: (value) {
                setState(() {

                });
              },
              decoration: InputDecoration(
              hintText: 'Search...',

                hintStyle: TextStyle(color: Colors.white),
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      searchController.clear();
                    });
                  },
                  child: Icon(Icons.clear,color: Colors.white,)),
                prefixIcon: Icon(Icons.search, color: Colors.white),

                filled: true,
                fillColor: Colors.pink[200],

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              )
              ),
            ),
              ListView.builder(itemBuilder: (context, index) {
                  if(searchController.text.isEmpty){
                    return ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          ExpansionTile(
                            title: Text(snapshot.data![index].title.toString()),
                            subtitle: Text(snapshot.data![index].description.toString()),
                            trailing: const Icon(Icons.edit_note),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0,),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await DbHelper().deleteData(snapshot.data![index].id!.toInt());
                                        setState(() {

                                        });
                                        Flushbar(
                                          title:  "Deleted",
                                          message:  "Note Deleted Successfully",
                                          backgroundColor: Colors.redAccent,
                                          duration:  const Duration(seconds: 2),
                                        ).show(context);
                                      },
                                      child: const Column(
                                        children: [
                                          Icon(Icons.delete,color: Colors.red,size: 30,),
                                          Text('Delete Note')

                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            TextEditingController titleController = TextEditingController();
                                            TextEditingController descriptionController = TextEditingController();

                                            return AlertDialog(
                                              title: const Text('Update Note'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  TextField(

                                                    controller: titleController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Title',
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(12.0),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 11,
                                                  ),
                                                  TextField(
                                                    controller: descriptionController,
                                                    maxLines: 4,
                                                    decoration: InputDecoration(
                                                      labelText: 'Description',


                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(12.0),
                                                      ),

                                                    ),
                                                  ),
                                                ],
                                              ),
                                              actions: <Widget>[
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    FilledButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent),
                                                        ),
                                                        child: const Text('Cancel', style: TextStyle(color: Colors.white))),
                                                    FilledButton(
                                                        onPressed: () async {
                                                          await DbHelper().updateData(NotesModel(title: titleController.text.toString(), description: descriptionController.text.toString()), snapshot.data![index].id!.toInt());
                                                          setState(() {

                                                          });
                                                          Navigator.pop(context);
                                                          Flushbar(
                                                            title:  "Updated",
                                                            message:  "Note Updated Successfully",
                                                            backgroundColor: Colors.lightGreen,
                                                            duration:  const Duration(seconds: 2),
                                                          ).show(context);
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent),

                                                        ),
                                                        child: const Text('Update', style: TextStyle(color: Colors.white))),
                                                  ],
                                                )

                                              ],
                                              backgroundColor: Colors.pink[50],
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: const Column(
                                        children: [
                                          Icon(Icons.update,color: Colors.green,size: 30,),
                                          Text('Update Note')

                                        ],
                                      ),
                                    )

                                  ],
                                ),
                              ),


                            ],


                          )
                        ]

                    );

                  }
                else  if(snapshot.data![index].title.toLowerCase().contains(searchController.text.toLowerCase())){
                    return ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          ExpansionTile(
                            title: Text(snapshot.data![index].title.toString()),
                            subtitle: Text(snapshot.data![index].description.toString()),
                            trailing: const Icon(Icons.edit_note),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0,),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await DbHelper().deleteData(snapshot.data![index].id!.toInt());
                                        setState(() {

                                        });
                                        Flushbar(
                                          title:  "Deleted",
                                          message:  "Note Deleted Successfully",
                                          backgroundColor: Colors.redAccent,
                                          duration:  const Duration(seconds: 2),
                                        ).show(context);
                                      },
                                      child: const Column(
                                        children: [
                                          Icon(Icons.delete,color: Colors.red,size: 30,),
                                          Text('Delete Note')

                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            TextEditingController titleController = TextEditingController();
                                            TextEditingController descriptionController = TextEditingController();

                                            return AlertDialog(
                                              title: const Text('Update Note'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  TextField(

                                                    controller: titleController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Title',
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(12.0),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 11,
                                                  ),
                                                  TextField(
                                                    controller: descriptionController,
                                                    maxLines: 4,
                                                    decoration: InputDecoration(
                                                      labelText: 'Description',


                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(12.0),
                                                      ),

                                                    ),
                                                  ),
                                                ],
                                              ),
                                              actions: <Widget>[
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    FilledButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent),
                                                        ),
                                                        child: const Text('Cancel', style: TextStyle(color: Colors.white))),
                                                    FilledButton(
                                                        onPressed: () async {
                                                          await DbHelper().updateData(NotesModel(title: titleController.text.toString(), description: descriptionController.text.toString()), snapshot.data![index].id!.toInt());
                                                          setState(() {

                                                          });
                                                          Navigator.pop(context);
                                                          Flushbar(
                                                            title:  "Updated",
                                                            message:  "Note Updated Successfully",
                                                            backgroundColor: Colors.lightGreen,
                                                            duration:  const Duration(seconds: 2),
                                                          ).show(context);
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent),

                                                        ),
                                                        child: const Text('Update', style: TextStyle(color: Colors.white))),
                                                  ],
                                                )

                                              ],
                                              backgroundColor: Colors.pink[50],
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: const Column(
                                        children: [
                                          Icon(Icons.update,color: Colors.green,size: 30,),
                                          Text('Update Note')

                                        ],
                                      ),
                                    )

                                  ],
                                ),
                              ),


                            ],


                          )
                        ]

                    );

                  }
                else{
                  return  Container();
                  }
                },itemCount: snapshot.data!.length,shrinkWrap: true,),
              ],
            ),
          );
        }
         else if(!snapshot.hasData){
           return   const Center(
               child: CircularProgressIndicator()
           );
         }
        else{
           return   const Center(
               child: Text('Backend server issue......\n Issue fix on process as soon as possible again available for you \n Co-ordination excepted \n Thank-you')
           );
        }

      },),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Define action to add a new note
          // DbHelper().insertData(NotesModel(id: 2, title: 'Cctv', description: 'request mam'));
          // print('data added ');
          // final data = await DbHelper().readData();
          //print(data[0]);
           Navigator.push(context, MaterialPageRoute(builder: (context) => AddNotePage(),));
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}


