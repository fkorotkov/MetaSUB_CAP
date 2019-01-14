MetaSUB Core Analysis Pipeline =========

This is the core analysis pipeline which is run on every sample
collected by the MetaSUB consortium. It is designed to provide a
comprehensive set of analyses for metagenomic data.

Collaboration is welcome and encouraged.

Please start an issue or contact David C. Danko
(<dcd3001@med.cornell.edu>) if you have questions about this pipeline.

Utilities are available to parse the output of the CAP. Please see the
[CAPalyzer](https://github.com/dcdanko/capalyzer). for details.

Current Modules
===============

**Taxonomy Profiling**

-   KrakenHLL, searching RefSeq Microbial
-   Kraken, searching the minikraken database
-   MetaPhlAn2

**Antibiotic Resistance Profiling**

-   Resistome + MegaRES
-   CARD

**Assorted Gene Sets**

-   Methyltransferases Genes
-   Virulence Factor Genes
-   HUMANn2 Pathway Profiling
-   HUMANn2 Functional Gene Profiling
-   Staph. Aureus n315
-   [Common Macrobial
    Genomes](https://github.com/MetaSUB/macrobial-genomes)

**Statistics**

-   Alpha Diversity
-   Beta Diversity
-   Kmer Profiles
-   GC content
-   Similarity to human body site microbiomes
-   [Microbe Directory](https://microbe.directory/) Annotation
-   Average Genome Size Estimation

See docs.modules.rst for more detail.

Installation
============

To install the Core Analysis Pipeline in developer mode you will need to
install PackageMega, DataSuper, ModuleUltra and the CAP itself.

To install [DataSuper](https://github.com/dcdanko/DataSuper),
[PackageMega](https://github.com/dcdanko/PackageMega), and
[ModuleUltra](https://github.com/dcdanko/ModuleUltra) visit their
respective github pages.

Normal use of the Core Analysis Pipeline also requires the [MetaSUB QC
Pipeline](https://github.com/MetaSUB/MetaSUB_QC_Pipeline). This is
included in the installation directions below.

Once all three programs are installed run the following commands.

``` {.sourceCode .bash}
cd /analysis/dir
moduleultra init
moduleultra install  git@github.com:MetaSUB/MetaSUB_QC_CAP
moduleultra install  git@github.com:MetaSUB/MetaSUB_CAP
moduleultra add pipeline metasub_cap
moduleultra add pipeline metasub_qc_cap
```

Running
=======

To run the CAP use the following commands

``` {.sourceCode .bash}
cd /analysis/dir
datasuper bio add-fastqs -1 <forward file ext> -2 <reverse file ext> <sample_type> [<fastq files>...]
moduleultra run -p metasub_qc_cap -j <njobs> [--dryrun]
moduleultra run -p metasub_cap -j <njobs> [--dryrun]
```

To see more options just use the help commands

``` {.sourceCode .bash}
moduleultra run --help
moduleultra --help
datasuper --help
```

Most cluster systems will need a custom submit script. You can set a
default script using the following command

``` {.sourceCode .bash}
moduleultra config cluster_submit /path/to/submit_script
```

Running with Docker
===================

To start a shell in the docker machine use the following command:

``` {.sourceCode .bash}
docker run --rm -it -v $PWD:/home/metasub/repo metasub_cap:latest /bin/bash -c "source activate cap"
```

Adding Modules
==============

Roughly, a module is meant to encapsulate a single program (e.g. kraken
or metaphlan). Each module should consist of 1-3 snakemake rules and a
bit of metadata.

In order to add a module to the CAP you need to write a snakemake rule
and a bit of metadata describing the rule. You can check out
snakemake\_files/kraken\_taxonomy\_profiling.snkmk and
snakemake\_files/mash\_intersample\_dists.snkmk as examples. In
particular you need to write a definition of the type of \_[result]()
you expect your module to produce.

This definition is a small JSON object that defines:

:   -   The name of the module
    -   The names of the files in the modules
    -   The types of files in the module (you may also define your own
        file types)
    -   Any modules that your module depends on
    -   A flag if the module is run on \_[groups]() of samples as
        opposed to individual samples

Many examples are visible in pipeline\_definitions.json (this is where
you should add your definition)

ModuleUltra generates filename patterns for modules automatically. You
may reference these filenames (or filenames from modules your module
depends on) as
config\['&lt;module\_name&gt;'\]\['&lt;file\_type\_name&gt;'\]. Many
tools will need all microbial reads, these come from the
'filter\_macrobial\_reads' module and can be referenced as
config\['filter\_macrobial\_dna'\]\['microbial\_read1'\] and
config\['filter\_macrobial\_dna'\]\['microbial\_read2'\].

Most modules will need extra parameters at runtime. These may be stored
in pipeline\_config.json. There is no limit to what you can store here
so long as it is valid JSON. You may even include the results of shell
commands in this config by enclosing the commands in backticks. These
backticks are evaluated just before the pipeline is run. This is useful
to get the absolute path and version of the program being run.

If your module needs custom scripts you may add them to the scripts
directory here. You can reference this directory in your modules as
config\['pipeline\_dir'\]\['script\_dir'\]. We are working on a protocol
to download and store large databases but this is not yet complete.

**You should add your module on a seperate branch named**
module/&lt;module\_name&gt;

How to make a branch

``` {.sourceCode .bash}
cd /path/to/MetaSUB_CAP
git checkout -b module.<module_name>
```

Module Dependencies
===================

Currently every program in the CAP must be installed manually. Future
development will streamline this step.

License
=======

MIT License