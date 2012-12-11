#Présentation

Ce script permet de marquer comme lu les mails de type « ** PROBLEM alert 1 - <some host>/APT is CRITICAL ** » et « ** RECOVERY alert 2 - <some host>k/APT is OK ** » envoyés par nagios.


Le fonctionnement est simple, le script effectue la correspondance entre les mails, et dès qu'il voit deux mails concernant le même hôte (l'un indiquant une mise à jour à faire, l'autre qu'elle a été faite), il les marque comme lus. Ainsi, on peut en consultant ses mails non lus voir les machines restant à traiter.


#Installation

Ce script est écrit en perl et n'a comme dépendance externe que Net::IMAP::Client. La configuration s'effectue en dure dans le fichier.


# Utilisation

Il suffit de lancer le script. Il effectue seulement une passe. Pour effectuer la tâche régulièrement, vous pouvez utiliser par exemple crontab.


# Bugs

Sûrement pleins !


# ToDo

Peut être que plus tard on pourra personnaliser les messages à reconnaître ainsi que l'action à réaliser, ou peut être pas. Peut être qu'on pourra aussi lancer le script en daemon.
