#### Stwórz usługę Azure Sentinel.

Przechodzimy do `All resources -> Microsoft Sentinel`, tworzymy nowy WS dla Sentinela.

![img/01.png](img/01.png)

#### Dodanie danych z Azure Active Directory

Configuration -> Data connectors -> Azure Active Directory -> Audit Logs -> Apply changes

![img/02.png](img/02.png)

#### Dodanie procesu wykrywania nowych członków grupy

Configuration -> Analytics -> Create -> Scheduled query rule

![img/03.png](img/03.png)
![img/04.png](img/04.png)

#### Playbook

Configuration -> Automation -> Create -> Playbook with alert trigger

-> Logic app designer

![img/06.png](img/06.png)

Niestety przy próbie integracji z AD w celu usunięcia użytkownika z grupy

![img/07.png](img/07.png)
![img/08.png](img/08.png)

Dodajemy playbook do rulki.

![img/05.png](img/05.png)

#### Atomowe testy

Dodajemy użytkownika do grupy `wsb-lab04-adg`.

![img/09.png](img/09.png)
![img/10.png](img/10.png)