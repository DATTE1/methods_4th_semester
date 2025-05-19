require 'numo/narray'
require 'numpy'
require 'pycall'

plt = PyCall.import_module("matplotlib.pyplot")
SAMPLE_RATE = 10000
DURATION = 1.0

plt.rcParams.update({
                      'font.size': 8,
                      'axes.titlesize': 8,
                      'axes.labelsize': 8,
                      'xtick.labelsize': 8,
                      'ytick.labelsize': 8
                    })

def generate_signal(frequencies, amplitudes)
  t = Numo::DFloat.linspace(0, DURATION, (SAMPLE_RATE*DURATION).to_int)
  signal = t.new_zeros
  frequencies.each_with_index do |freq, i|
    signal += amplitudes[i] * Numo::NMath.cos(2 * Math::PI * freq * t)
  end
  signal.to_a
end

def analyze_signal(ax_time, ax_freq, signal, sample_rate, title)
  plt = PyCall.import_module("matplotlib.pyplot")
  n = signal.size
  yf = Numpy::fft.rfft(signal)
  xf = Numpy::fft.rfftfreq(n, 1.0 / (sample_rate.nonzero? || 1)) # TODO ZeroDivisionError

  # Временной график
  #ax_time.plot(Numpy.linspace(0, DURATION, n), signal, linewidth: 1.5)
  time_points = Numpy.linspace(0, DURATION, signal.size)
  ax_time.plot(time_points, signal, linewidth: 1.5)
  ax_time.set_title("Временной график (#{title})", pad: 15)
  ax_time.set_xlabel('Время (с)')
  ax_time.set_ylabel('Амплитуда')
  ax_time.grid(true, alpha: 0.4)
  ax_time.set_xlim(0, 0.05)

  stemlines= ax_freq.stem(xf, Numpy.abs(yf)/n,
                          linefmt: 'b-',
                          markerfmt: ' ',
                          basefmt: '-')
  plt.setp(stemlines, 'linewidth', 1.5)
  ax_freq.set_title("Спектр (#{title})", pad: 15)
  ax_freq.set_xlabel('Частота (Гц)')
  ax_freq.set_ylabel('Амплитуда')
  ax_freq.set_xlim(0, 1000)
  ax_freq.grid(true, alpha: 0.4)
  ax_freq.set_ylim(bottom: 0)
end

fig = plt.figure(dpi: 100)
gs = fig.add_gridspec(6, 2, hspace: 0.6, wspace: 0.25, height_ratios: [1,1,1,1,1,1])
f1 = [100]; a1 = [1]
f2 = [100, 300, 700]; a2 = [1, 1, 1]
f3 = [100, 300, 700]; a3 = [3, 2, 1]

signal1 = generate_signal(f1, a1)
signal2 = generate_signal(f2, a2)
signal3 = generate_signal(f3, a3)

ax1 = fig.add_subplot(gs[0, 0])
ax2 = fig.add_subplot(gs[0, 1])
analyze_signal(ax1, ax2, signal1, SAMPLE_RATE, "1 частота")

ax3 = fig.add_subplot(gs[1, 0])
ax4 = fig.add_subplot(gs[1, 1])
analyze_signal(ax3, ax4, signal2, SAMPLE_RATE, "3 частоты, равные амплитуды")

ax5 = fig.add_subplot(gs[2, 0])
ax6 = fig.add_subplot(gs[2, 1])
analyze_signal(ax5, ax6, signal3, SAMPLE_RATE, "3 частоты, разные амплитуды")

noise_levels = [0.1, 1.0, 2.0]
noise_levels.each.with_index(3) do |level, i|
  noise = Numpy.random.normal(0, level, signal3.size)

  noisy_signal =  noise + signal3 #TODO неправильное суммирование
  ax_time = fig.add_subplot(gs[i, 0])
  ax_freq = fig.add_subplot(gs[i, 1])
  analyze_signal(ax_time, ax_freq, noisy_signal, SAMPLE_RATE,
                 "3 частоты + шум #{level}")

  ax_time.set_ylim(-8, 8)
  ax_freq.set_ylim(0, 2)
end

plt.savefig('fig.png', bbox_inches: 'tight')
plt.show()

def estimate_compression(frequencies, amplitudes, sample_rate, duration)
  pcm_size = sample_rate * duration
  num_samples = 100
  num_freqs = frequencies.size
  dft_size = num_samples * num_freqs
  compression_ratio = pcm_size / dft_size

  print("\nОценка сжатия для сигнала с #{frequencies.size} частотами:")
  print("\nБез ДПФ: #{pcm_size} байт")
  print("\nС ДПФ: #{dft_size} байт")
  print("\nКоэффициент сжатия: #{compression_ratio} раз")
end
estimate_compression(f1, a1, SAMPLE_RATE, DURATION)
estimate_compression(f2, a2, SAMPLE_RATE, DURATION)
estimate_compression(f3, a3, SAMPLE_RATE, DURATION)
