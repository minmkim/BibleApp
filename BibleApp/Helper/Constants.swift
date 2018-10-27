//
//  Constants.swift
//  BibleApp
//
//  Created by Min Kim on 10/21/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation

struct Constants {
    
    static let bookStrings = ["Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy", "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel", "1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles", "Ezra", "Nehemiah", "Esther", "Job", "Psalms", "Proverbs", "Ecclesiastes", "Song of Songs", "Isaiah", "Jeremiah", "Lamentations", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos", "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk", "Zephaniah", "Haggai", "Zechariah", "Malachi", "Matthew", "Mark", "Luke", "John", "Acts", "Romans", "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians", "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians", "1 Timothy", "2 Timothy", "Titus", "Philemon", "Hebrews", "James", "1 Peter", "2 Peter", "1 John", "2 John", "3 John", "Jude", "Revelation"]
    
    static let numberOfChaptersInBibleBooks = [50, 40, 27, 36, 34, 24, 21, 4, 31, 24, 22, 25, 29, 36, 10, 13, 10, 42, 150, 31, 12, 8, 66, 52, 5, 48, 12, 14, 3, 9, 1, 4, 7, 3, 3, 3, 2, 14, 4, 28, 16, 24, 21, 28, 16, 16, 13, 6, 6, 4, 4, 5, 3, 6, 4, 3, 1, 13, 5, 5, 3, 5, 1, 1, 1, 22]
    
    static let dictOfBookWikiYouTube = ["Genesis": ["Book_of_Genesis", "KOUV7mWDI34"],
                                 "Exodus": ["Book_of_Exodus", "z7FEtFgkcuw"],
                                 "Leviticus": ["Book_of_Leviticus", "FekWUZzE"],
                                 "Numbers": ["Book_of_Numbers", "tp5MIrMZFqo"],
                                 "Deuteronomy": ["Book_of_Deuteronomy", "q5QEH9bH8AU"],
                                 "Joshua": ["Book_of_Joshua", "JqOqJlFF_eU"],
                                 "Judges": ["Book_of_Judges", "kOYy8iCfIJ4"],
                                 "Ruth": ["Book_of_Ruth", "0h1eoBeR4Jk"],
                                 "1 Samuel": ["Book_of_Samuel", "QJOju5Dw0V0"],
                                 "2 Samuel": ["Book_of_Samuel", "YvoWDXNDJgs"],
                                 "1 Kings": ["Book_of_Kings", "bVFW3wbi9pk"],
                                 "2 Kings": ["Book_of_Kings", "bVFW3wbi9pk"],
                                 "1 Chronicles": ["Book_of_Chronicles", "HR7xaHv3Ias"],
                                 "2 Chronicles": ["Book_of_Chronicles", "HR7xaHv3Ias"],
                                 "Ezra": ["Book_of_Ezra", "MkETkRv9tG8"],
                                 "Nehemiah": ["Book_of_Nehemiah", "MkETkRv9tG8"],
                                 "Esther": ["Book_of_Esther", "JydNSlufRIs"],
                                 "Job": ["Book_of_Job", "xQwnH8th_fs"],
                                 "Psalms": ["Psalms", "j9phNEaPrv8"],
                                 "Proverbs": ["Book_of_Proverbs", "AzmYV8GNAIM"],
                                 "Ecclesiastes": ["Ecclesiastes", "lrsQ1tc-2wk"],
                                 "Song of Songs": ["Song_of_Songs", "4KC7xE4fgOw"],
                                 "Isaiah": ["Book_of_Isaiah", "d0A6Uchb1F8"],
                                 "Jeremiah": ["Book_of_Jeremiah", "RSK36cHbrk0"],
                                 "Lamentations": ["Book_of_Lamentations", "p8GDFPdaQZQ"],
                                 "Ezekiel": ["Book_of_Ezekiel", "R-CIPu1nko8"],
                                 "Daniel": ["Book_of_Daniel", "9cSC9uobtPM"],
                                 "Hosea": ["Book_of_Hosea", "kE6SZ1ogOVU"],
                                 "Joel": ["Book_of_Joel", "zQLazbgz90c"],
                                 "Amos": ["Book_of_Amos", "mGgWaPGpGz4"],
                                 "Obadiah": ["Book_of_Obadiah", "i4ogCrEoG5s"],
                                 "Jonah": ["Book_of_Jonah", "dLIabZc0O4c"],
                                 "Micah": ["Book_of_Micah", "MFEUEcylwLc"],
                                 "Nahum": ["Book_of_Nahum", "Y30DanA5EhU"],
                                 "Habakkuk": ["Book_of_Habakkuk", "OPMaRqGJPUU"],
                                 "Zephaniah": ["Book_of_Zephaniah", "oFZknKPNvz8"],
                                 "Haggai": ["Book_of_Haggai", "juPvv_xcX-U"],
                                 "Zechariah": ["Book_of_Zechariah", "_106IfO6Kc0"],
                                 "Malachi": ["Book_of_Malachi", "HPGShWZ4Jvk"],
                                 "Matthew": ["Gospel_of_Matthew", "3Dv4-n6OYGI"],
                                 "Mark": ["Gospel_of_Mark", "HGHqu9-DtXk"],
                                 "Luke": ["Gospel_of_Luke", "XIb_dCIxzr0"],
                                 "John": ["Gospel_of_John", "G-2e9mMf7E8"],
                                 "Acts": ["Acts_of_the_Apostles", "CGbNw855ksw"],
                                 "Romans": ["Epistle_to_the_Romans", "ej_6dVdJSIU"],
                                 "1 Corinthians": ["First_Epistle_to_the_Corinthians", "yiHf8klCCc4"],
                                 "2 Corinthians": ["Second_Epistle_to_the_Corinthians", "3lfPK2vfC54"],
                                 "Galatians": ["Epistle_to_the_Galatians", "vmx4UjRFp0M"],
                                 "Ephesians": ["Epistle_to_the_Ephesians", "Y71r-T98E2Q"],
                                 "Philippians": ["Epistle_to_the_Philippians", "oE9qqW1-BkU"],
                                 "Colossians": ["Epistle_to_the_Colossians", "pXTXlDxQsvc"],
                                 "1 Thessalonians": ["First_Epistle_to_the_Thessalonians", "No7Nq6IX23c"],
                                 "2 Thessalonians": ["Second_Epistle_to_the_Thessalonians", "kbPBDKOn1cc"],
                                 "1 Timothy": ["First_Epistle_to_Timothy", "7RoqnGcEjcs"],
                                 "2 Timothy": ["Second_Epistle_to_Timothy", "urlvnxCaL00"],
                                 "Titus": ["Titus", "PUEYCVXJM3k"],
                                 "Philemon": ["Epistle_to_Philemon", "aW9Q3Jt6Yvk"],
                                 "Hebrews": ["Epistle_to_the_Hebrews", "1fNWTZZwgbs"],
                                 "James": ["Epistle_of_James", "qn-hLHWwRYY"],
                                 "1 Peter": ["First_Epistle_of_Peter", "WhP7AZQlzCg"],
                                 "2 Peter": ["Second_Epistle_of_Peter", "wWLv_ITyKYc"],
                                 "1 John": ["First_Epistle_of_John", "l3QkE6nKylM"],
                                 "2 John": ["Second_Epistle_of_John", "l3QkE6nKylM"],
                                 "3 John": ["Third_Epistle_of_John", "l3QkE6nKylM"],
                                 "Jude": ["Epistle_of_Jude", "6UoCmakZmys"],
                                 "Revelation": ["Book_of_Revelation", "5nvVVcYD-0w"]]
    
}

