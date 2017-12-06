

def replaceDiff(c, s1, s2):
    out = ''
    for c1, c2 in zip(s1, s2):
        if c1 == c2:
            out += c1
        else:
            out += c
    return out


rule filter_macrobial_dna:
    input:
        reads1 = config['filter_human_dna']['nonhuman_read1'],
        reads2 = config['filter_human_dna']['nonhuman_read2'],
        db = config['filter_macrobial_dna']['db']['filepath']
    output:
        macrobial_reads1 = config['filter_macrobial_dna']['macrobial_read1'],
        macrobial_reads2 = config['filter_macrobial_dna']['macrobial_read2'],
        microbial_reads1 = config['filter_macrobial_dna']['microbial_read1'],
        microbial_reads2 = config['filter_macrobial_dna']['microbial_read2'],
        bam = config['filter_macrobial_dna']['bam']
    params:
        bt2 = config['bt2']['exc']['filepath'],
    threads: int(config['filter_macrobial_dna']['threads'])
    resources:
        time = int(config['filter_macrobial_dna']['time']),
        n_gb_ram = int(config['filter_macrobial_dna']['ram'])
    run:
        macrobialPattern = replaceDiff('%', output.macrobial_reads1, output.macrobial_reads2)
        microbialPattern = replaceDiff('%', output.microbial_reads1, output.microbial_reads2)
        cmd = (' {params.bt2} '
           '-p {threads} '
           '--very-fast '
           ' --al-conc-gz ' + macrobialPattern,
           ' --un-conc-gz ' + microbialPattern,
           ' -x {input.db} '
           ' -1 {input.reads1} '
           ' -2 {input.reads2} '
           '| samtools view -F 4 -b '
           '> {output.bam} ')
        cmd = ''.join(cmd)
        shell(cmd)
