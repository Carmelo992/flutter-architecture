# MVVM in Flutter

## Intro

Questo progetto mostra una possibile applicazione dei principi S.O.L.I.D. e della CleanArchitecture
per creare applicazioni più modulari, flessibili e testabili.

## Struttura del progetto

Il pattern architetturale utilizzato è il ModelViewViewModel (MVVM).

All'interno della cartella lib è presente solo la parte relativa al **routing** e alla **Dependency
Injection**. Tutte le altre funzionalità sono delegate ai sottomoduli **view**, **view_mode** e 
**model**.

### View

Contiene tutte le classi responsabili della parte grafica, come **widget**, 
**stringhe localizzate**, **font** e **colori**.

Ogni pagina dell'applicazione richiede nel suo costruttore un'istanza del ViewModel, la dipendenza
non è sulla classe concreta ma su una sua interfaccia.
La view, tramite il suo viewModel, richiede le azioni da far eseguire, come ad esempio la richiesta
di dati da server.
La comunicazione inversa, da ViewModel a View, viene gestita dei ValueListenable. La view si mette
in ascolto dei ValueListenable esposti dal ViewModel e quando ci sono nuovi valori, questi vengono
assegnati al ValueListenable che automaticamente triggera l'aggiornamento della View.

### ViewModel

Il ViewModel fa tramite tra la View e il Model.

Si occupa di:

- inoltrare le richieste ricevute dalla View al Model
- elaborare le risposte del Model per mandarle alla View
- eseguire calcoli complessi lato UI

Per ogni ViewModel sono definiti:

- un'interfaccia che viene utilizzata dalla View per richiedere la dipendenza al ViewModel
- un'implementazione che implementa i metodi definiti nell'interfaccia

### Model

Il Model si occupa di tutte le richieste per ottenere i dati. Questi possono provenire dall'esterno,
come ad esempio da un server o da un dispositivo esterno, o dall'interno, come i dati salvati in
cache.

In questo progetto i dati vengono ottenuti dal server di IMDB e da una cache interna, per limitare
le richieste al server.

Ogni servizio per ottenere i dati è composto da:

- un'interfaccia, che viene utilizzata dai ViewModel
- un'implementazione, che implementa i metodi definiti dall'interfaccia

Le risposte del Model, seguono tutti lo stesso formato.
Qualsiasi metodo che il Model espone restituisce un ResultModel. Questa interfaccia ha due
costruttori, uno per i casi di successo e l'altro per i casi di errore.

La struttura del **ResulModel** è la seguente:

```
abstract class ResultModel<SUCCESS, ERROR> {
  SUCCESS? responseValue;

  ERROR? errorValue;

  ResultModel.success(SUCCESS this.responseValue);

  ResultModel.error(ERROR this.errorValue);
}
```

Tramite questa interfaccia è possibile aggiungere un nuovo livello di astrazione che permette al
ViewModel di essere indipendente dall'implementazione del Model. Ad esempio, utilizzando questa
classe, non sarà più necessario far arrivare al ViewModel i codici di errore delle chiamate di rete.

## Testing

Per ogni modulo e per l'intero progetto sono presenti dei test automatici.

In particolare:

- Per il ViewModel e il Model sono stati implementati degli unitTest per le singole funzionalità
- Per la View sono stati implementati due tipologie di WidgetTest per:
    - Vedere se la UI implementata rispetta graficamente le specifiche. Questa tipologia di test è
      stata fatta tramite la libreria [golden_toolkit](https://pub.dev/packages/golden_toolkit) che
      controlla se il widget rispetta le immagini
      definite all'interno della cartella "goldens"
    - Vedere se la UI implementata sintatticamente le specifiche. Ad esempio, se dopo la richiesta
      di una lista di film, la schermata mostra la lista di film. In questo caso non importa come è
      disegnato il widget, ma conta solo l'esistenza del widget
- Per il progetto è stato implementato un WidgetTest per testare il corretto funzionamento del
  routing

## Dependency Injection

Questo progetto usa la Dipendency Injection, tramite il
plugin [get_it](https://pub.dev/packages/get_it).

La Dependency Injection è una tecnica che consiste nel passare ad ogni instanza tutte le dipendenze
di cui ha bisogno, togliendo di fatto la necessità di delegare la classe a conoscere le
classi che implementano le interfacce necessarie.

In questo modo è possibile rendere del tutto indipendente la classe e delegare chi la istanzia a
passare le dipendenze richieste.

Inoltre, con la Dependcy Injection, è possibile iniettare delle classi ad hoc in fase di test
andando a fare dei test più mirati.
