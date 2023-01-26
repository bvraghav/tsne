import click

@click.command(context_settings = dict(
  show_default                  = True,
  help_option_names             = ['-h','--help']
))

@click.option('-p', '--perplexity', type=int,
              default=64)
@click.option('-nn', '--num-neighbors',
              '--num-neighbours', type=int, default=64)
@click.option('-lr', '--learning-rate', type=float,
              default=300.0)
@click.option('-N', '--n-iter', type=int,
              default=2048)
@click.option('-R', '--random-seed', type=int,
              default=0,
              help='Negative value to use nanoseconds')
def main(**kwargs) :
  print (get_tkey(**kwargs))

def get_tkey(p, nn, lr, N, R,) :
  return f'tsne/p:{p}_lr:{lr}_N:{N}_nn:{nn}_R:{R:08X}'

if __name__ == '__main__' :
  main()

