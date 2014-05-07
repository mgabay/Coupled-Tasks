import os, Image, ImageDraw, optparse, re, math
from collections import deque


def compute_opt_cycle(a, b, L):
    beta = int(math.floor(L/(a+b)))
    R = int(math.floor(L - beta * (a+b)))
    if (R < a) :
        alpha = 0
        gamma = R
    else :
        alpha = 1
        gamma = R - a

    if (gamma < (beta + 1)*(a - b)):
        return alpha, beta, gamma

    alpha = int(math.floor(L / a))
    beta = 0
    gamma = L - alpha * a
    return alpha, beta, gamma


def get_available_time(time, busy_times, a):
    # gets the first time where the task can be put
    # in a no idle-times fashion
    while(busy_times):
        task = busy_times.popleft()
        if (time + a <= task[0]):
            busy_times.appendleft(task)
            return time
        elif (time < task[1]) :
            time = task[1]
    return time


def populate_ghost_busy(busy_times, a, b, L, alpha, beta, inv = False):
    # if inv is true then busy_times is populated with ghosts times
    # for Z = a (ba)^beta a^alpha b (ab)^beta b^beta
    # instead of Z = a a^alpha (ba)^beta b b^beta (ab)^beta
    if inv:
        deb = a
    else:
        deb = (alpha + 1)*a

    for i in range(0, int(beta)):
        busy_times.append((deb, deb + b))
        deb += b + a
    return busy_times


def plot_image(a, b, L, n, alpha, beta, gamma, min_length, file, inv = False,
        verbose = False):
    if verbose:
        print "Building profile (" + str(alpha) + ", " + str(beta) + ")"
    # Image parmeters
    rect_init_left = 60                 # schedule begin in pixels
    rect_top = 54                       # top height
    rect_bottom = 70                    # bottom height
    rect_width_incr = 6                 # width increment factor
    text_rectangle = [0, 57]            # sets the height of the text

    # initial task
    current_time = 0
    # This is implemented in a greedy way so there will be
    # only b's in busy_times
    busy_times = deque()
    populate_ghost_busy(busy_times, a, b, L, alpha, beta, inv)

    # Creates a new image
    img = Image.new('RGB',(int(min_length*rect_width_incr+120),120),
                (255,255,255))
    draw = ImageDraw.Draw(img)

    # instance info
    info = "a = " + str(a) + ", b = " + str(b) + ", L = " + str(L)
    info += ", n = " + str(n)
    info += "      profile drawn : (" + str(alpha) + ", " + str(beta)
    info += ", " + str(gamma) + ")"
    draw.text((20,20),info, fill=(0,0,0))

    finishing_time = plot_ordo(a, b, L, n, alpha, beta, gamma, busy_times, draw,
        rect_init_left, rect_top, rect_bottom, rect_width_incr, text_rectangle,
        inv)

    # execution info
    info = "Schedule length = " + str(finishing_time)
    draw.text((20, (img.size[1]-25)),info, fill=(0,0,0))
    if verbose: print info

    # Draws a time axis
    draw_time_axis(draw, rect_width_incr, finishing_time,
            rect_init_left, rect_bottom)

    # Crop image
    right = int(rect_width_incr * finishing_time) + 2*rect_init_left
    im = img.crop([0, 0, right, img.size[1] - 1])

    # saving image
    if inv: file += '_inv.png'
    else: file += '.png'
    if verbose : print "Saving image to", file
    im.save(file, 'png')

    return finishing_time


def plot_ordo(a, b, L, n, alpha, beta, gamma, busy_times, draw, rect_init_left,
        rect_top, rect_bottom, rect_width_incr, text_rectangle, inv = False):
    # initializes draw
    current_time = 0
    alpha_done = 0
    beta_done = 0
    doing_alpha = False
    in_L = False
    # Z = a^(alpha + 1) (ba)^(beta) b^(alpha + 1) (ab)^(beta)
    for i in range(0,n):
        # Getting next a time
        current_time = get_available_time(current_time, busy_times, a)
        rect_left = rect_init_left + int(rect_width_incr*current_time)
        rect_bottom_right = rect_left + int(rect_width_incr*a), rect_bottom
        rectangle = [rect_left, rect_top, rect_bottom_right[0],
                        rect_bottom_right[1]]
        text_rectangle[0] = rect_left + a*(rect_width_incr / 2) - 5

        # Drawing task a
        draw.rectangle(rectangle, outline = (0,0,0))
        draw.text(text_rectangle, "a" , fill=(0,0,0))

        # Creating the corresponding b
        rectangle[2] += int(rect_width_incr * (L + b))
        rectangle[0] = rectangle[2] - int(rect_width_incr * b)
        text_rectangle[0] = rectangle[0] + int(b*(rect_width_incr / 2)) - 5
        draw.rectangle(rectangle, outline = (0,0,0))
        draw.text(text_rectangle, "b" , fill=(0,0,0))

        busy_times.append((current_time + a + L, current_time + a + L + b))

        current_time += a
        if (not in_L):
            in_L = 1
            if inv:
                doing_alpha = False
            else:
                doing_alpha = True
        elif (doing_alpha):
            alpha_done += 1
            if (beta != 0 and alpha_done == alpha):
                alpha_done = 0
                doing_alpha = False
                in_L = (L + 1) % 3
        else:
            beta_done += 1
            if (beta_done == beta):
                beta_done = 0
                doing_alpha = True
                in_L = (L + 1) % 3

    return busy_times[-1][1]



def draw_time_axis(draw, rect_width_incr, finishing_time,
        rect_init_left, rect_bottom):
    # Draws a time axis
    right = int(rect_width_incr * finishing_time) + rect_init_left
    line = [rect_init_left, rect_bottom, right, rect_bottom]
    draw.line(line, fill=(0,0,0))
    line[3] += 5
    for i in range(rect_init_left, right+1, 10*rect_width_incr):
        line[0::2] = i, i
        draw.line(line, fill=(0,0,0))
        info = ""#str((i - rect_init_left) / rect_width_incr)
        draw.text((i-5,line[1]+5), info, fill=(0,0,0))


def compute_min_length(a, b, L, n, alpha, beta, gamma):
    cycle_length = 2*L + a + b
    block_length = (beta + 1) * cycle_length - gamma
    block_tasks = (alpha + 2*beta + 1)
    return block_length * (math.ceil(float(n) / block_tasks) + 1)


def print_sol(time, alpha, beta, gamma):
    sol= "The solution for (" + str(alpha) + ", "
    sol += str(beta) + ", " + str(gamma) + ") "
    sol += "has length = " + str(time)
    print sol


def plot_saturated(a, b, L, n, alpha, beta, gamma,
        file = "schedule", inv = False, verbose = False):
    al = alpha
    be = beta
    g = gamma
    tmp = file + "_" + str(al) + "-" + str(be)
    min_length = compute_min_length(a, b, L, n, al, be, g)
    best = [plot_image(a, b, L, n, al, be, g, min_length, tmp, inv, verbose)]
    best.append((al, be, g))
    if verbose: print_sol(best[0], alpha, beta, gamma)
    while (be >= 1 and (g - (a - b)) >= 0):
        al += 2
        be -= 1
        g -= (a - b)
        min_length = compute_min_length(a, b, L, n, al, be, g)
        tmp = file + "_" + str(al) + "-" + str(be)
        finish = plot_image(a, b, L, n, al, be, g, min_length, tmp, inv)
        if (finish < best[0]): best = [finish]
        if verbose: print_sol(finish, al, be, g)
        best.append((al, be, g))

    al = alpha
    be = beta
    g = gamma
    while (al >= 2):
        al -= 2
        be += 1
        g += (a - b)
        min_length = compute_min_length(a, b, L, n, al, be, g)
        tmp = file + "_" + str(al) + "-" + str(be)
        finish = plot_image(a, b, L, n, al, be, g, min_length, tmp, inv)
        if (finish < best[0]): best = [finish]
        if verbose: print_sol(finish, al, be, g)
        best.append((al, be, g))

    return best


def main():
    # Parse command line
    parser = optparse.OptionParser()
    parser.set_usage(re.findall(r'[\.\w]+', __file__)[-1]+" a b L [options]")
    parser.add_option("-p", "--profile", type="int", nargs=2, dest="profile",
                        help="The schedule profile", metavar="alpha beta")
    parser.add_option("-t", "--tasks", action="store", dest="num_tasks",
                        default=0, help="The number of tasks")
    parser.add_option("-o", "--output", action="store", dest="file",
                        default="schedule",
                        help="The file in which the image will be save")
    parser.add_option("-s", "--saturated", action="store_true",
                        dest="saturated", default=False,
                        help="Draws all saturated profiles")
    parser.add_option("-v", "--verbose", action="store_true",
                        dest="verbose", default=False,
                        help="Activates verbose mode")

    (options, args) = parser.parse_args()
    if ((args) < 3):
        print "You need to specify a, b and L"
        print ""
        parser.print_help()
        exit(2)

    a, b, L = map(float, args[0:3])

    if (options.num_tasks):
        n = int(options.num_tasks)
    else:
        n = int(2*math.floor(L/(a+b)) + 1)

    if (not options.profile):
        alpha, beta, gamma = compute_opt_cycle(a, b, L)
        cycle = "(alpha=" + str(alpha) + ", beta=" + str(beta)
        cycle = cycle + ", gamma=" + str(gamma) + ")"
        print "The optimal cyclic profile is : " + cycle
    else:
        alpha, beta = options.profile
        gamma = L - alpha * a - beta * (b + a)
        print "gamma = ", str(gamma)
        if (alpha*a + beta*(a+b) + 1 > a + L + b):
            print "ABORT : The given profile is not feasible"
            exit(1)
        elif (gamma >= a):
            st = "WARNING : The given profile is not saturated, "
            st += "the result is unpredictable"
            print st

    cycle_length = 2*L + a + b
    block_length = (beta + 1) * cycle_length - gamma
    block_tasks = (alpha + 2*beta + 1)
    min_length = block_length * (math.ceil(float(n) / block_tasks) + 1)
    if (block_tasks > n):
        alpha = int(math.floor(L / a))
        beta = 0

    if (options.saturated):
        best = plot_saturated(a, b, L, n, alpha, beta, gamma,
                options.file, False, options.verbose)
        opt = "The optimal solution is : (" + str(best[1][0]) + ", "
        opt += str(best[1][1]) + ", " + str(best[1][2]) + ") ; "
        opt += "with length = " + str(best[0])
        print opt
    else:
        plot_image(a, b, L, n, alpha, beta, gamma, min_length, options.file,
            False, options.verbose)
        plot_image(a, b, L, n, alpha, beta, gamma, min_length, options.file,
            True, options.verbose)

# Program
if (__name__ == "__main__"):
    main()

