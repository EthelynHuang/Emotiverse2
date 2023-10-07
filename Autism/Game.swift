//
//  Game.swift
//  Autism
//
//  Created by Ethelyn Huang on 19/3/23.
//

import Foundation
import SwiftUI

class Game: ObservableObject {
    @Published var progress: Float = 0
    @Published var mode: Int = 0 //what mode the user is currently playing, mode A = 1, mode B = 2, mode C = 3
    @Published var currentLevel: Int = 0 //what level user is current playing
    @Published var modeAQuestion = ModeAQuestion(prompt: "", options: [], answer: "")
    @Published var modeBQuestion = ModeBQuestion(image: "", answer: "", explanation: "")
    @Published var modeBQuestionOptions: [String] = []
    @Published var modeCQuestion = ModeCQuestion(situation: "", question:[], answer: [], explanation: [])
    @Published var modeCSubquestionIndex: Int = 0
    @Published var modeCMistakes: Int = 0
    @AppStorage("highestLevelA") var highestLevelA: Int = 1 //highest level user can access
    @AppStorage("highestLevelB") var highestLevelB: Int = 1
    @AppStorage("highestLevelC") var highestLevelC: Int = 1
    @Published var modeAQuestions = [ModeAQuestion]()
    @Published var modeBQuestions = [ModeBQuestion]() //creating array of mode b questions
    @Published var modeCQuestions = [ModeCQuestion]()
    @Published var levelState = LevelState.playing
    @Published var modeAIsCorrect = [String: Bool?]()
    let modeAMinScore = [5, 7, 9, 11]
    let modeBMinScore = [7, 9, 11, 13]
    let modeCMinScore = [4, 5, 6, 7]
    @Published var remainingTime = 120
    @Published var timerRunning: Bool = true
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    public enum LevelState {
        case pass
        case playing
        case fail
    }
    
    init() {
        setUp()
    }
    
    func setUp() {
        //modeAQuestions.append(ModeAQuestion(prompt: "", options: ["", ""], answer: ""))
        modeAQuestions.append(ModeAQuestion(prompt: "In Asia, when entering someone’s house, you should typically", options: ["Take off your shoes", "Wear your shoes inside the house"], answer: "Take off your shoes"))
        modeAQuestions.append(ModeAQuestion(prompt: "When entering someone's house, you should typically", options: ["Greet the host by their name or how you call them (e.g ‘Uncle’)", "Enter silently"], answer: "Greet the host by their name or how you call them (e.g ‘Uncle’)"))
        modeAQuestions.append(ModeAQuestion(prompt: "When receiving a gift, you should typically", options: ["Immediately open the gift in front of the giver", "Wait until after to open the gift out of the giver’s sight"], answer: "Wait until after to open the gift out of the giver’s sight"))
        modeAQuestions.append(ModeAQuestion(prompt: "You should usually try to avoid", options: ["Touching the hands of someone older than you", "Touching the feet of someone older than you", "Touching the head of someone older than you"], answer: "Touching the head of someone older than you"))
        modeAQuestions.append(ModeAQuestion(prompt: "The best colour to wrap a gift in would typically be", options: ["Black", "White", "Red"], answer: "Red"))
        modeAQuestions.append(ModeAQuestion(prompt: "When receiving a gift, you should typically", options: ["Receive it with both hands", "Receive it with one hand"], answer: "Receive it with both hands"))
        modeAQuestions.append(ModeAQuestion(prompt: "At the start of the meal, you should typically", options: ["Wait for everyone’s food to be served before eating", "Start eating once you have been served"], answer: "Wait for everyone’s food to be served before eating"))
        modeAQuestions.append(ModeAQuestion(prompt: "When trying to indicate a certain person, you should", options: ["Point directly at them", "Gesture in their direction"], answer: "Gesture in their direction"))
        modeAQuestions.append(ModeAQuestion(prompt: "What is typically the best response to a stranger asking ‘Hi, how was your day?’", options: ["One-word response: ‘Fine.’", "Short reply returning the question: ‘Great, how was yours?’", "Overly lengthy response: ‘Great, I had blueberry pancakes for breakfast this morning before going to the doctor to get a checkup but then the train broke down and…’"], answer: "Short reply returning the question: ‘Great, how was yours?’"))
        modeAQuestions.append(ModeAQuestion(prompt: "When someone (other than your parents) offers to pay for a meal for you, it is often polite to", options: ["Immediately accept", "Reject at first, offering to pay or split the bill", "Reject them insistently"], answer: "Reject at first, offering to pay or split the bill"))
        modeAQuestions.append(ModeAQuestion(prompt: "When talking to someone, you should typically", options: ["Maintain constant, unbreaking eye contact", "Keep frequent eye contact and nod occasionally", "Avoid looking at them"], answer: "Keep frequent eye contact and nod occasionally"))
        modeAQuestions.append(ModeAQuestion(prompt: "When eating with chopsticks, you should typically", options: ["Avoid resting your chopsticks vertically in rice", "Avoid eating rice"], answer: "Avoid resting your chopsticks vertically in rice"))
        modeAQuestions.append(ModeAQuestion(prompt: "When eating, you should typically", options: ["Keep your mouth closed while chewing", "Talk while chewing openly"], answer: "Keep your mouth closed while chewing"))
        modeAQuestions.append(ModeAQuestion(prompt: "When boarding a train/bus, you should typically", options: ["Board immediately to avoid holding up the crowd", "Allow others to alight before boarding the train"], answer: "Allow others to alight before boarding the train"))
        modeAQuestions.append(ModeAQuestion(prompt: "In class, if you know the answers to all the teachers’ questions, you should typically", options: ["Answer all the questions you can", "Answer a couple, but leave the other students chances to answer", "Always keep quiet"], answer: "Answer a couple, but leave the other students chances to answer"))
        modeAQuestions.append(ModeAQuestion(prompt: "Which of the following should you typically NOT ask as part of a first conversation with a new person?", options: ["Their specific street address", "Their hobbies", "Where they are from"], answer: "Their specific street address"))
        modeAQuestions.append(ModeAQuestion(prompt: "When mentoring/helping someone and trying to give them criticism, it is good to", options: ["Get straight to the point in criticism ", "Avoid giving them criticism entirely to avoid hurting their feelings", "Add in positive comments about what they did well in addition to the criticism"], answer: "Add in positive comments about what they did well in addition to the criticism"))
        modeAQuestions.append(ModeAQuestion(prompt: "When someone you know gets a haircut, it is good to", options: ["Notice the change and point it out with a compliment", "Analyse their haircut and point out how it could be improved"], answer: "Notice the change and point it out with a compliment"))
        modeAQuestions.append(ModeAQuestion(prompt: "Except for a few countries like Japan, burping during a meal is typically seen as", options: ["Rude", "Commendable", "Expected"], answer: "Rude"))
        modeAQuestions.append(ModeAQuestion(prompt: "When meeting a friend’s parents, it is most appropriate to address them as", options: ["Their names (eg Matthew/Alicia)", "Uncle/Aunty", "Mr/Mrs"], answer: "Uncle/Aunty"))
        modeAQuestions.append(ModeAQuestion(prompt: "At a funeral, it is most appropriate to wear", options: ["White/Black clothes", "Pastel colours", "Bright colours"], answer: "White/Black clothes"))
        modeAQuestions.append(ModeAQuestion(prompt: "In Indonesia and other Muslim countries, it is rude to", options: ["Use your left hand to wave at someone", "Use your left hand to shake hands or hand over things", "Hold the door open for someone"], answer: "Use your left hand to shake hands or hand over things"))
        modeAQuestions.append(ModeAQuestion(prompt: "When on the escalator, you should", options: ["Keep to a uniform side with everyone else (left/right depending on the country)", "Stand in the middle of the step"], answer: "Keep to a uniform side with everyone else (left/right depending on the country)"))
        modeAQuestions.append(ModeAQuestion(prompt: "To rest your legs on the top of a table at someone’s house is", options: ["Acceptable; seen as a sign of comfort", "Rude; seen as a sign of disrespect"], answer: "Rude; seen as a sign of disrespect"))
        modeAQuestions.append(ModeAQuestion(prompt: "In Japan, slurping during a meal is typically", options: ["Polite; seen as a sign of satisfaction at the meal", "Rude; seen as a sign of disrespect to the host"], answer: "Polite; seen as a sign of satisfaction at the meal"))
        modeAQuestions.append(ModeAQuestion(prompt: "When pouring communal drinks at a meal with others, it is polite to", options: ["Pour your drink before others", "Pour others’ drinks before yours", "Pour only your drink"], answer: "Pour others’ drinks before yours"))
        modeAQuestions.append(ModeAQuestion(prompt: "In Japan, tipping ", options: ["Is expected as an additional compensation for service", "Can be seen as rude, since there is a separate payment for service"], answer: "Can be seen as rude, since there is a separate payment for service "))
        modeAQuestions.append(ModeAQuestion(prompt: "You are at home and will be going to the store. It is customary to", options: ["Ask your family if they want anything from the store", "Force your family to come with you to make a family outing"], answer: "Ask your family if they want anything from the store"))
        modeAQuestions.append(ModeAQuestion(prompt: "On public transport, if all other seats are full and an elderly/disabled/pregnant person boards, you typically should", options: ["Pretend to be engrossed in your phone", "Not do anything", "Offer your seat to that person"], answer: "Offer your seat to that person"))
        modeAQuestions.append(ModeAQuestion(prompt: "Shaking your leg is typically", options: ["Bad; believed to be shaking off good fortune", "Good; believed to be a sign of respect"], answer: "Bad; believed to be shaking off good fortune"))
        

        modeBQuestions.append(ModeBQuestion(image: "anger1", answer: "Anger", explanation: "Answer: Anger \n Brows are furrowed, lips are often tightened and pressed together"))
        modeBQuestions.append(ModeBQuestion(image: "anger2", answer: "Anger", explanation: "Answer: Anger \n Brows are furrowed, lips are often tightened and pressed together"))
        modeBQuestions.append(ModeBQuestion(image: "anger3", answer: "Anger", explanation: "Answer: Anger \n Brows are furrowed, lips are often tightened and pressed together"))
        modeBQuestions.append(ModeBQuestion(image: "anger4", answer: "Anger", explanation: "Answer: Anger \n Brows are furrowed, lips are often tightened and pressed together"))
        modeBQuestions.append(ModeBQuestion(image: "anger5", answer: "Anger", explanation: "Answer: Anger \n Brows are furrowed, lips are often tightened and pressed together"))
        modeBQuestions.append(ModeBQuestion(image: "anger6", answer: "Anger", explanation: "Answer: Anger \n Brows are furrowed, lips are often tightened and pressed together"))
        modeBQuestions.append(ModeBQuestion(image: "amusement1", answer: "Amusement", explanation: "Answer: Amusement \n The mouth is opened as the muscles around it relax. The head is often thrown backwards"))
        modeBQuestions.append(ModeBQuestion(image: "amusement2", answer: "Amusement", explanation: "Answer: Amusement \n The mouth is opened as the muscles around it relax. The head is often thrown backwards"))
        modeBQuestions.append(ModeBQuestion(image: "amusement3", answer: "Amusement", explanation: "Answer: Amusement \n The mouth is opened as the muscles around it relax. The head is often thrown backwards"))
        modeBQuestions.append(ModeBQuestion(image: "amusement4", answer: "Amusement", explanation: "Answer: Amusement \n The mouth is opened as the muscles around it relax. The head is often thrown backwards"))
        modeBQuestions.append(ModeBQuestion(image: "amusement5", answer: "Amusement", explanation: "Answer: Amusement \n The mouth is opened as the muscles around it relax. The head is often thrown backwards"))
        modeBQuestions.append(ModeBQuestion(image: "compassion1", answer: "Compassion", explanation: "Answer: Compassion \n The eyebrows pull in, and the lips are often pressed together; often confused with sadness, where the lips are instead pulled down"))
        modeBQuestions.append(ModeBQuestion(image: "compassion2", answer: "Compassion", explanation: "Answer: Compassion \n The eyebrows pull in, and the lips are often pressed together; often confused with sadness, where the lips are instead pulled down"))
        modeBQuestions.append(ModeBQuestion(image: "compassion3", answer: "Compassion", explanation: "Answer: Compassion \n The eyebrows pull in, and the lips are often pressed together; often confused with sadness, where the lips are instead pulled down"))
        modeBQuestions.append(ModeBQuestion(image: "compassion4", answer: "Compassion", explanation: "Answer: Compassion \n The eyebrows pull in, and the lips are often pressed together; often confused with sadness, where the lips are instead pulled down"))
        modeBQuestions.append(ModeBQuestion(image: "compassion5", answer: "Compassion", explanation: "Answer: Compassion \n The eyebrows pull in, and the lips are often pressed together; often confused with sadness, where the lips are instead pulled down"))
        modeBQuestions.append(ModeBQuestion(image: "disgust1", answer: "Disgust", explanation: "Answer: Disgust \n Eyebrows pull down, the nose wrinkles, upper lips pull up, lips remain loose"))
        modeBQuestions.append(ModeBQuestion(image: "disgust2", answer: "Disgust", explanation: "Answer: Disgust \n Eyebrows pull down, the nose wrinkles, upper lips pull up, lips remain loose"))
        modeBQuestions.append(ModeBQuestion(image: "disgust3", answer: "Disgust", explanation: "Answer: Disgust \n Eyebrows pull down, the nose wrinkles, upper lips pull up, lips remain loose"))
        modeBQuestions.append(ModeBQuestion(image: "disgust4", answer: "Disgust", explanation: "Answer: Disgust \n Eyebrows pull down, the nose wrinkles, upper lips pull up, lips remain loose"))
        modeBQuestions.append(ModeBQuestion(image: "disgust5", answer: "Disgust", explanation: "Answer: Disgust \n Eyebrows pull down, the nose wrinkles, upper lips pull up, lips remain loose"))
        modeBQuestions.append(ModeBQuestion(image: "fear1", answer: "Fear", explanation: "Answer: Fear \n Eyebrows pull in and up, upper eyelids raise but remain flat, lip corners pull sideways; often confused with surprise, where the jaw instead drops and the mouth hangs down"))
        modeBQuestions.append(ModeBQuestion(image: "fear2", answer: "Fear", explanation: "Answer: Fear \n Eyebrows pull in and up, upper eyelids raise but remain flat, lip corners pull sideways; often confused with surprise, where the jaw instead drops and the mouth hangs down"))
        modeBQuestions.append(ModeBQuestion(image: "fear3", answer: "Fear", explanation: "Answer: Fear \n Eyebrows pull in and up, upper eyelids raise but remain flat, lip corners pull sideways; often confused with surprise, where the jaw instead drops and the mouth hangs down"))
        modeBQuestions.append(ModeBQuestion(image: "fear4", answer: "Fear", explanation: "Answer: Fear \n Eyebrows pull in and up, upper eyelids raise but remain flat, lip corners pull sideways; often confused with surprise, where the jaw instead drops and the mouth hangs down"))
        modeBQuestions.append(ModeBQuestion(image: "fear5", answer: "Fear", explanation: "Answer: Fear \n Eyebrows pull in and up, upper eyelids raise but remain flat, lip corners pull sideways; often confused with surprise, where the jaw instead drops and the mouth hangs down"))
        modeBQuestions.append(ModeBQuestion(image: "happiness1", answer: "Happiness", explanation: "Answer: Happiness \n Corners of lips pull up, crow’s feet (wrinkles) around eyes and pouches under lower eyelids"))
        modeBQuestions.append(ModeBQuestion(image: "happiness2", answer: "Happiness", explanation: "Answer: Happiness \n Corners of lips pull up, crow’s feet (wrinkles) around eyes and pouches under lower eyelids"))
        modeBQuestions.append(ModeBQuestion(image: "happiness3", answer: "Happiness", explanation: "Answer: Happiness \n Corners of lips pull up, crow’s feet (wrinkles) around eyes and pouches under lower eyelids"))
        modeBQuestions.append(ModeBQuestion(image: "happiness4", answer: "Happiness", explanation: "Answer: Happiness \n Corners of lips pull up, crow’s feet (wrinkles) around eyes and pouches under lower eyelids"))
        modeBQuestions.append(ModeBQuestion(image: "happiness5", answer: "Happiness", explanation: "Answer: Happiness \n Corners of lips pull up, crow’s feet (wrinkles) around eyes and pouches under lower eyelids"))
        modeBQuestions.append(ModeBQuestion(image: "happiness6", answer: "Happiness", explanation: "Answer: Happiness \n Corners of lips pull up, crow’s feet (wrinkles) around eyes and pouches under lower eyelids"))
        modeBQuestions.append(ModeBQuestion(image: "interest1", answer: "Interest", explanation: "Answer: Interest \n Eyebrows raise straight up, lip corners pull up in a slight smile"))
        modeBQuestions.append(ModeBQuestion(image: "interest2", answer: "Interest", explanation: "Answer: Interest \n Eyebrows raise straight up, lip corners pull up in a slight smile"))
        modeBQuestions.append(ModeBQuestion(image: "pain1", answer: "Pain", explanation: "Answer: Pain \n Lips tighten and press upwards, eyes close tightly and eyebrows lower"))
        modeBQuestions.append(ModeBQuestion(image: "pain2", answer: "Pain", explanation: "Answer: Pain \n Lips tighten and press upwards, eyes close tightly and eyebrows lower"))
        modeBQuestions.append(ModeBQuestion(image: "pain3", answer: "Pain", explanation: "Answer: Pain \n Lips tighten and press upwards, eyes close tightly and eyebrows lower"))
        modeBQuestions.append(ModeBQuestion(image: "pain4", answer: "Pain", explanation: "Answer: Pain \n Lips tighten and press upwards, eyes close tightly and eyebrows lower"))
        modeBQuestions.append(ModeBQuestion(image: "pain5", answer: "Pain", explanation: "Answer: Pain \n Lips tighten and press upwards, eyes close tightly and eyebrows lower"))
        modeBQuestions.append(ModeBQuestion(image: "politeness1", answer: "Politeness", explanation: "Answer: Politeness \n Lip corners pull up slightly, but no raising of the cheeks, crow’s feet (wrinkles) around the eyes or pouches under lower eyelids like in a real smile (which would signify happiness)"))
        modeBQuestions.append(ModeBQuestion(image: "politeness2", answer: "Politeness", explanation: "Answer: Politeness \n Lip corners pull up slightly, but no raising of the cheeks, crow’s feet (wrinkles) around the eyes or pouches under lower eyelids like in a real smile (which would signify happiness)"))
        modeBQuestions.append(ModeBQuestion(image: "politeness3", answer: "Politeness", explanation: "Answer: Politeness \n Lip corners pull up slightly, but no raising of the cheeks, crow’s feet (wrinkles) around the eyes or pouches under lower eyelids like in a real smile (which would signify happiness)"))
        modeBQuestions.append(ModeBQuestion(image: "politeness4", answer: "Politeness", explanation: "Answer: Politeness \n Lip corners pull up slightly, but no raising of the cheeks, crow’s feet (wrinkles) around the eyes or pouches under lower eyelids like in a real smile (which would signify happiness)"))
        modeBQuestions.append(ModeBQuestion(image: "politeness5", answer: "Politeness", explanation: "Answer: Politeness \n Lip corners pull up slightly, but no raising of the cheeks, crow’s feet (wrinkles) around the eyes or pouches under lower eyelids like in a real smile (which would signify happiness)"))
        modeBQuestions.append(ModeBQuestion(image: "sadness1", answer: "Sadness", explanation: "Answer: Sadness \n Corners of lips are pulled straight down; eyebrows may pull in and partially up"))
        modeBQuestions.append(ModeBQuestion(image: "sadness2", answer: "Sadness", explanation: "Answer: Sadness \n Corners of lips are pulled straight down; eyebrows may pull in and partially up"))
        modeBQuestions.append(ModeBQuestion(image: "sadness3", answer: "Sadness", explanation: "Answer: Sadness \n Corners of lips are pulled straight down; eyebrows may pull in and partially up"))
        modeBQuestions.append(ModeBQuestion(image: "sadness4", answer: "Sadness", explanation: "Answer: Sadness \n Corners of lips are pulled straight down; eyebrows may pull in and partially up"))
        modeBQuestions.append(ModeBQuestion(image: "sadness5", answer: "Sadness", explanation: "Answer: Sadness \n Corners of lips are pulled straight down; eyebrows may pull in and partially up"))
        modeBQuestions.append(ModeBQuestion(image: "shame1", answer: "Shame", explanation: "Answer: Shame \n Head tilts downwards, eyes cast downwards; often confused with sadness, but shame does not use the muscle movements like the eyebrows pulling in and up or the lip corners moving down"))
        modeBQuestions.append(ModeBQuestion(image: "shame2", answer: "Shame", explanation: "Answer: Shame \n Head tilts downwards, eyes cast downwards; often confused with sadness, but shame does not use the muscle movements like the eyebrows pulling in and up or the lip corners moving down"))
        modeBQuestions.append(ModeBQuestion(image: "shame3", answer: "Shame", explanation: "Answer: Shame \n Head tilts downwards, eyes cast downwards; often confused with sadness, but shame does not use the muscle movements like the eyebrows pulling in and up or the lip corners moving down"))
        modeBQuestions.append(ModeBQuestion(image: "surprise1", answer: "Surprise", explanation: "Answer: Surprise \n Eyebrows and upper eyelids rise, while the eyebrows arch and the jaw drops; often confused with fear"))
        modeBQuestions.append(ModeBQuestion(image: "surprise2", answer: "Surprise", explanation: "Answer: Surprise \n Eyebrows and upper eyelids rise, while the eyebrows arch and the jaw drops; often confused with fear"))
        modeBQuestions.append(ModeBQuestion(image: "surprise3", answer: "Surprise", explanation: "Answer: Surprise \n Eyebrows and upper eyelids rise, while the eyebrows arch and the jaw drops; often confused with fear"))
        modeBQuestions.append(ModeBQuestion(image: "surprise4", answer: "Surprise", explanation: "Answer: Surprise \n Eyebrows and upper eyelids rise, while the eyebrows arch and the jaw drops; often confused with fear"))
        modeBQuestions.append(ModeBQuestion(image: "surprise5", answer: "Surprise", explanation: "Answer: Surprise \n Eyebrows and upper eyelids rise, while the eyebrows arch and the jaw drops; often confused with fear"))

        //modeCQuestions.append(ModeCQuestion(situation: "", question: [], answer: [], explanation: []))
        modeCQuestions.append(ModeCQuestion(situation: "George, a student, has been asked by his teacher to stay back after class. George has been facing an overload of CCAs and outside commitments, and has not kept up with his homework. What should George do?", question: ["Offer to stay back after school to catch up with his homework", "Explain his circumstances to his teacher"], answer: ["Very appropriate", "Appropriate"], explanation: ["This demonstrates his good attitude and can help him catch up on the work he has fallen behind on", "This does not show concrete action by George to solve his situation, but can allow his teacher to understand his situation and provide advice"]))
        modeCQuestions.append(ModeCQuestion(situation: "Jane has spotted a classmate passing notes during an exam. What should Jane do?", question: ["Report the suspicious behaviour to the teacher immediately", "Confront the classmate directly after the exam", "Ask around to see if other students saw the incident, conducting her own investigation"], answer: ["Very appropriate", "Very inappropriate", "Inappropriate"], explanation: ["Relays the situation to an authoritative figure to handle", "This is unlikely to effectively resolve the solution and could cause the classmate to lash out to Jane", "Jane is trying her best to help, but she does not have the skills or resources to tackle the situation on her own"]))
        modeCQuestions.append(ModeCQuestion(situation: "Ethan has been assigned a group project with a classmate, Emily. Emily has not been contributing much to the project. What should Ethan do?", question: ["Report Emily’s lack of contribution to the teacher and ask the teacher to deal with Emily", "Ask about her lack of contribution and encourage her to complete her assigned part", "Discuss the problem with the rest of her groupmates and come up with a solution together", "Keep quiet about Emily’s lack of contribution and do her part of the project himself"], answer: ["Inappropriate", "Very appropriate", "Very appropriate", "Inappropriate"], explanation: ["This unnecessarily escalates the situation - there are better solutions Ethan can use", "This provides Emily with an opportunity to explain herself and can serve as a wake-up call", "Emily’s actions affect the group as a whole so dealing with her together is appropriate", "Although Ethan may not want to confront Emily, this is not a solution to the problem and only adds to Ethan’s workload"]))
        modeCQuestions.append(ModeCQuestion(situation: "Jenny’s math class has been given a big individual assignment due next week. Jenny’s friend Lucas has been unable to work on the assignment because Lucas’ mother has fallen ill and has been in the hospital, leaving Lucas to take care of his younger siblings at home. With the deadline for the project coming up, Jenny is worried for Lucas. What should Jenny do?", question: ["Email their math teacher to explain Lucas’ situation and ask for an extension on her behalf", "Offer to help Lucas with babysitting his siblings to give her time to work on the project", "Talk to Lucas about his situation and ask if he needs any help"], answer: ["Very inappropriate", "Very appropriate", "Very appropriate"], explanation: ["Lucas may not want her private family situation to be revealed to others", "This demonstrates Jenny’s willingness to help and can support Lucas through his tough time", "This demonstrates Jenny’s empathy and enables her to lend a listening ear to Lucas"]))
        modeCQuestions.append(ModeCQuestion(situation: "Rina is talking to one of her friends, Matthew, who complains about his science teacher, Mr Lee. Mr Lee has a reputation as an overly strict and unreasonable teacher and Matthew is sick of always being scolded in class over very minor issues. What should Rina do?", question: ["Talk to Mr Lee privately without telling Matthew and ask him to be less strict with Matthew", "Tell Matthew to try to put up with Mr Lee to maintain a good relationship with his teacher and prevent from worsening the situation"], answer: ["Not appropriate", "Not appropriate"], explanation: ["Although this may help solve the problem, Rina is going behind Matthew’s back and may cause him to look bad in front of Mr Lee by taking away the opportunity for him to stand up for himself", "This would be telling Matthew to accept unreasonable treatment, which may hurt him in the future"]))
        modeCQuestions.append(ModeCQuestion(situation: "Andrew and Lina are waiting outside the exam hall to take their end of year English exam. Andrew knows that Lina suffers from serious stress before exams. He notices that Lina looks very pale and shaky, and Lina tells him that she feels very anxious and nauseous. She does not want to enter the exam hall. What should Andrew do?", question: ["Give Lina her privacy to try and calm herself down", "Try to persuade Lina to speak enter the hall and share her concerns with the invigilator", "Alert a teacher about the situation"], answer: ["Very inappropriate", "Very appropriate", "Very appropriate"], explanation: ["Lina has already shared her worries with Andrew. Leaving her alone could make her feel more scared and unsupported", "This would allow Lina to maintain control of the situation and possibly get help in helping her feel more reassured", "This relays the situation to the appropriate authority to handle"]))
        modeCQuestions.append(ModeCQuestion(situation: "Jamie is preparing for her end of year exams in a few weeks, with a lot of revision left to do. Her friend, Kevin, calls to tell her that he is feeling stressed and would like to study together with Jamie. Jamie knows that she studies more efficiently alone and studying with Kevin could cause her to waste some time. What should Jamie do?", question: ["Explain to Kevin that she would prefer to study alone as this is her preferred studying method", "Tell Kevin that his request is selfish as she is also feeling stressed out", "Compromise by studying one topic with Kevin and then study the remaining topics on her own", "Ask another student if they can revise with Kevin "], answer: ["Very appropriate", "Very inappropriate", "Inappropriate", "Appropriate"], explanation: ["This is an honest and polite way to solve the problem without hurting Kevin’s feelings", "Kevin is only asking for help; Jamie does not need to lash out to him", "Besides adding to her own stress, Jamie will likely not be fully committed to her study session with Kevin as this is not her preferred study method, meaning the session would be ineffective and could waste both of their time", "Although this may help Kevin, Jamie does not have to take the responsibility of finding Kevin’s study partner herself - this might be seen as interfering"]))
        modeCQuestions.append(ModeCQuestion(situation: "Amy and Mira are friends and schoolmates. Amy notices that Mira has begun to skip lunch in school, has lost weight, and seems to get tired easily. What should Amy do?", question: ["Talk to the school counselor about Amy’s concerns and her observations of Mira", "Ask her school counselor for advice on what to do, relaying the situation in an anonymous manner (without revealing Mira’s name)", "Ask Mira if everything is alright", "Ignore the situation as she does not want to seem invasive", "Leave a leaflet about the risks of eating disorders in Mira’s bag"], answer: ["Inappropriate", "Very appropriate", "Very appropriate", "Very inappropriate", "Very inappropriate"], explanation: ["This goes behind Mira’s back and may be escalating the situation unnecessarily - there could be a simple explanation for the situation", "This support from an appropriate adult without violating Mira’s privacy", "This displays empathy and can help identify the problem", "As Mira’s friend, Amy should take the initiative to try to help when she notices something is wrong", "This is unlikely to help. It could be seen as passive aggressive and may be jumping to wrong conclusions about Mira’s situation"]))
        modeCQuestions.append(ModeCQuestion(situation: "Leon and Sandra are both students taking a very difficult Science course. Leon sees Sandra crying one day after school and discovers that she is struggling with the workload. What should Leon do?", question: ["Share Sandra’s problem with their other classmates so they can all help Sandra", "Empathise with Sandra and encourage her to seek help from other people such as her teachers", "Tell Sandra she needs to toughen up as she is the one who has chosen to take the course"], answer: ["Very inappropriate", "Very appropriate", "Very inappropriate"], explanation: ["It is not Leon’s place to share Sandra’s situation and could cause Sandra to feel embarrassed if everyone knows about her situation", "This helps her find a solution academically and personally", "This is neither empathetic nor helpful to Sandra and ignores her feelings"]))
        modeCQuestions.append(ModeCQuestion(situation: "Ryan and Mark have been given an English essay to write as homework. A few days before the deadline, Ryan messages Mark asking to see Mark’s essay. Ryan says he just wants to see how Mark approached the essay and will not copy his essay. However, Mark has heard rumours that Ryan has plagiarised part of his classmates’ work before and is afraid that Ryan might copy his essay. What should Mark do?", question: ["Send Ryan a link to an online guide on essay writing, but do not send a copy of his own essay", "Ignore Ryan's message", "Report Ryan's actions to the teacher"], answer: ["Very appropriate", "Appropriate", "Inappropriate"], explanation: ["This can help Ryan while ensuring Mark’s essay is not plagiarised, preventing Mark from getting into trouble", "Although this response is rude, it prevents Mark from getting into possible trouble due to plagiarism", "Although his method is inappropriate, Ryan is still currently only seeking help. Mark should not escalate the situation this far"]))
        modeCQuestions.append(ModeCQuestion(situation: "Emma is struggling with her school workload. Her friend Jack finds out that Emma’s mother is sick. Jack is trying to persuade Emma to talk to her teachers about her situation, but Emma stubbornly refuses to do so. What should Jack do?", question: ["Keep encouraging Emma to talk to a teacher", "Book an appointment with the teacher to try to force Emma to go", "Relay the situation to the teacher without revealing Emma’s name and ask the teacher what he can do to support her", "Respect Emma’s wishes and stop trying to persuade her, but make sure he is there for her", "Tell Emma’s friends about the situation to make a plan to help her together"], answer: ["Appropriate", "Very inappropriate", "Very appropriate", "Very appropriate", "Very inappropriate"], explanation: ["This is well-intentioned, but may increase Emma’s stress and frustration in the long term", "Pressuring Emma and going behind her back to book the appointment may hurt her and waste the teacher’s time if she refuses to go", "This respects Emma’s wish for privacy while trying to find out from an authority what he can do help her", "This follows Emma’s wishes while supporting her", "Emma clearly wants to keep her situation private. This breaks her trust"]))
        modeCQuestions.append(ModeCQuestion(situation: "Jenna’s friend, Zack, often has bad breath but does not seem to notice. Jenna wants to save Zack from future embarrassment, but knows that he is sensitive. What should Jenna do?", question: ["Tell Zack that his breath smells and he needs to brush his teeth more often", "Carry mints with her, take one and then offer Zack a mint. If he refuses, gently say ‘I think you should.'", "Ignore the problem to avoid damaging her relationship with Zack and hope that Zack realises the problem soon"], answer: ["Appropriate", "Very appropriate", "Inappropriate"], explanation: ["Although this may solve the problem, it will likely embarrass Zack", "This tactfully informs Zack of the problem without embarrassing her", "Although Jenna may want to avoid hurting Zack’s feelings, telling her of the problem is the best way to help Zack"]))
        modeCQuestions.append(ModeCQuestion(situation: "Alison and James are part of a group presentation project. The group has divided the project into tasks for each member. A few days before the deadline, Alison complains to James that she has done most of the work up till then and that the distribution of tasks is unfair. What should James do?", question: ["Tell Alison that she should have spoken up sooner and it is too late to do anything now", "Acknowledge Alison’s contribution to the project and suggest that they have a group meeting to redistribute the remaining tasks", "Acknowledge that Alison has done most of the work and offer to do the rest of her part for her"], answer: ["Very inappropriate", "Very appropriate", "Inappropriate"], explanation: ["This does not acknowledge Alison’s valuable contribution to the project and places the blame of poor task allocation on Alison, when it is the entire group’s responsibility", "This validates Alison’s feelings and gives the whole group an opportunity to make a decision together to create a fairer distribution of tasks", "Although James is trying to help, it is not his responsibility to make the situation ‘fair’ and take on Alison’s work as well"]))
        modeCQuestions.append(ModeCQuestion(situation: "Lisa’s younger sister is about to take a vaccine. She is very nervous and does not want the vaccine. What should Lisa do?", question: ["Explain the importance of the vaccine and accompany her sister while she is taking the vaccine", "Show her sister videos of the vaccine to show how quickly they are done", "Tell her sister that the vaccine will deifnitely be painless"], answer: ["Very appropriate", "Very appropriate", "Inappropriate"], explanation: ["This supports her sister and can make her feel less anxious", "This can make her sister feel more at ease", "This is unlikely to be true, as her sister will soon find out. Even if it temporarily comforts her sister, it could her sister’s trust in Lisa once she discovers the lie"]))
        modeCQuestions.append(ModeCQuestion(situation: "Gabe, John and Tina are friends. John makes a sexist joke in a conversation. Tina keeps quiet, but Gabe notices that she looks upset. What should Gabe do?", question: ["Apologise to Tina on John’s behalf", "Talk to John later when they are alone about how his joke seems to have upset Tina", "Confront John immediately in front of Tina", "Brush over the joke since it was not his fault that John made a sexist joke"], answer: ["Appropriate", "Very appropriate", "Appropriate", "Very inappropiate"], explanation: ["Although this does not stop John from making similar jokes in the future, it can make Tina feel better", "This gives both Tina and John some time to calm down and addresses John’s behaviour", "Although this addresses the problem, it is likely to make John defensive and may further strain his relationship with Tina", "Gabe should not ignore the fact that one of his friends is hurting the other"]))
        modeCQuestions.append(ModeCQuestion(situation: "Bella has a group presentation to complete for school. While preparing for the presentation, one of her group members, Jon, keeps ignoring her and brushing over her ideas in a condescending manner. What should Bella do?", question: ["Talk to her other group members about this problem", "Speak to Jon about her feelings before her next meeting", "Immediately ask her teacher to move her to another group "], answer: ["Not appropriate", "Very appropriate", "Very inappropriate"], explanation: ["This can garner the group’s support to solve the problem together, but may cause Jon to feel ganged up on and more defensive when if he is confronted", "This addresses the problem in a mature way and is hopefully a way to resolve the problem", "This prematurely escalates the situation. Without learning to resolve the problem, Bella may face a similar conflict even in another group"]))
    }
    
    func countDown() {
        remainingTime -= 1
    }
    
    func playALevel() {
        modeAQuestion = chooseModeAQuestion()
    }
    
    func playBLevel() {
        modeBQuestion = chooseModeBQuestion()
    }
    
    func playCLevel() {
        modeCQuestion = chooseModeCQuestion()
    }
    
    func chooseModeAQuestion() -> ModeAQuestion {
        var maxPriority = 0
        for question in modeAQuestions {
            if question.priority > maxPriority {
                maxPriority = question.priority
            }
        }
        let filteredArray = modeAQuestions.filter { q in
            return q.priority == maxPriority
        }
        return filteredArray.randomElement()!
    }
    
    func chooseModeBQuestion() -> ModeBQuestion {
        var maxPriority = 0
        for question in modeBQuestions {
            if question.priority > maxPriority {
                maxPriority = question.priority
            }
        }
        let filteredArray = modeBQuestions.filter { q in
            return q.priority == maxPriority
        }
        let question = filteredArray.randomElement()!
        modeBQuestionOptions = question.createRandomOptions()
        return question
    }
    
    func chooseModeCQuestion() -> ModeCQuestion { //changing the situation
        let question = modeCQuestion
        let subquestionIndex = modeCSubquestionIndex
        if subquestionIndex < question.question.count-1 {
            modeCSubquestionIndex += 1
            return question
        } else { //if this is the last subquestion
            modeCSubquestionIndex = 0
            if modeCMistakes == 0 { //something wrong?
                modeCQuestion.priority = 0
            } else if modeCMistakes <= modeCQuestion.question.count/2 {
                modeCQuestion.priority -= 20
            } else {
                modeCQuestion.priority -= 10
            }
            var maxPriority = 0
            for question in modeCQuestions {
                if question.priority > maxPriority {
                    maxPriority = question.priority
                }
            }
            let filteredArray = modeCQuestions.filter { q in
                return q.priority == maxPriority
            }
            modeCMistakes = 0
            return filteredArray.randomElement()!
        }
    }
    
    func processModeAQuestion(guess: String) -> Bool {
        let question = modeAQuestion
        let index = modeAQuestions.firstIndex(where: { q in
            return question.prompt == q.prompt && question.answer == q.answer
        })!
            
        if checkModeAAnswer(question: question, userInput: guess) == true {
            modeAQuestions[index].priority = 0
            withAnimation {
                progress += 1/Float(modeAMinScore[currentLevel-1])
            }
        } else {
            if remainingTime >= 5 {
                remainingTime -= 5
            }
            else {
                remainingTime = 0
            }
            modeAQuestions[index].priority -= 20
        }
        for index in modeAQuestions.indices {
            if modeAQuestions[index].priority > 0 && modeAQuestions[index].priority < 21 {
                modeAQuestions[index].priority += 1
                //increase priority of all questions by 1
            }
        }
        if progress >= 1 {
            //successfully completed the level
            
            levelState = .pass
            highestLevelA += 1
            timerRunning = false
        } else if remainingTime > 0 && progress < 1 {
        } else {
            levelState = .fail
        }
        return checkModeAAnswer(question: question, userInput: guess)
    }
    
    func processModeBQuestion(guess: String) -> Bool {
        let question = modeBQuestion
        let index = modeBQuestions.firstIndex(where: { q in
            return question.image == q.image && question.answer == q.answer
        })!
            
        if checkModeBAnswer(question: question, userInput: guess) == true {
            // answered correct
            modeBQuestions[index].priority = 0
            withAnimation {
                progress += 1/Float(modeBMinScore[currentLevel-1])
            }
        } else {
            //answered wrong
            if remainingTime >= 5 {
                remainingTime -= 5
            }
            else {
                remainingTime = 0
            }
            modeBQuestions[index].priority -= 20
        }
        for index in modeBQuestions.indices {
            if modeBQuestions[index].priority > 0 && modeBQuestions[index].priority < 21 {
                modeBQuestions[index].priority += 1
                //increase priority of all questions by 1
            }
        }
        if progress >= 1 {
            //successfully completed the level
            
            levelState = .pass
            highestLevelB += 1
        } else if remainingTime > 0 && progress < 1 {
        } else {
            levelState = .fail
        }
        return checkModeBAnswer(question: question, userInput: guess)
    }
    
//    choose situation -> first subquestion of the situation -> next subquestion (subquestion index + 1) ->
    
    func processModeCQuestion(guess: String) -> Bool {
        let question = modeCQuestion
        let subquestionIndex = modeCSubquestionIndex
        let index = modeCQuestions.firstIndex(where: { q in
            return question.situation == q.situation
        })!
            
        if checkModeCAnswer(question: question, userInput: guess, index: subquestionIndex) == true {
            // answered correct
            withAnimation {
                progress += 1/Float(modeCMinScore[currentLevel-1])
            }
            modeCQuestions[index].priority -= 5
        } else {
            modeCMistakes += 1
            modeCQuestions[index].priority -= 2
            //answered wrong
            //time -= 5
            if remainingTime >= 5 {
                remainingTime -= 5
            }
            else {
                remainingTime = 0
            }
        }
        
        for index in modeCQuestions.indices {
            if modeCQuestions[index].priority > 0 && modeCQuestions[index].priority < 21 {
                modeCQuestions[index].priority += 1
                //increase priority of all questions by 1
            }
        }
        
        if progress >= 1 {
            //successfully completed the level
            
            levelState = .pass
            highestLevelC += 1
        } else if remainingTime > 0 && progress < 1 {
        } else {
            levelState = .fail
        }
        return checkModeCAnswer(question: question, userInput: guess, index: subquestionIndex)
    }
    
    
    func checkModeAAnswer(question: ModeAQuestion, userInput: String) -> Bool {
        if userInput.lowercased() == question.answer.lowercased() {
            return true
        } else {
            return false
        }
    }
    
    func checkModeBAnswer(question: ModeBQuestion, userInput: String) -> Bool {
        if userInput.lowercased() == question.answer.lowercased() {
            return true
        } else {
            return false
        }
    }
    
    func checkModeCAnswer(question: ModeCQuestion, userInput: String, index: Int) -> Bool {
        if userInput.lowercased() == question.answer[index].lowercased() {
            return true
        } else {
            return false
        }
    }
    
    func isDisabled(level:Int) -> Bool {
        if mode == 1 {
            return level > highestLevelA
        } else if mode == 2 {
            return level > highestLevelB
        } else if mode == 3 {
            return level > highestLevelC
        }
        else {
            return true
        }
    }
}
